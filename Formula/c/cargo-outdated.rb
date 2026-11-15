class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  stable do
    url "https://github.com/kbknapp/cargo-outdated/archive/refs/tags/v0.19.0.tar.gz"
    sha256 "ea6592c08d4e8ea53aa0251cbbfbf8ad2b2167f794cb9599715eecb3653507f2"

    # Backport openssl-sys update
    patch do
      url "https://github.com/kbknapp/cargo-outdated/commit/2681b1c2ffad45ccbb35e027804b6bf39fc4b75e.patch?full_index=1"
      sha256 "8115a7b5bbbb204c44f250d494d1e24df2d9e6473ab247fa6c342014a1f85e1b"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5133c6014beedcac9f9a99a2113b5f99ae9be6e5f1255ceccc2027f9af8b731e"
    sha256 cellar: :any, arm64_tahoe:       "6a8ec88fedc2756ded1261eba129932024a0da9cbcf307c5157af24f3d82b5fa"
    sha256 cellar: :any, arm64_sequoia:     "ad7fa0f96b961bab42632af270929a9a0f486ea0ee5710d41b0946b6790dee11"
    sha256 cellar: :any, arm64_linux:       "a93da6a70017159d4535346522aee8763cbbfc299a36f83bfbdc8da0672b6fbb"
    sha256 cellar: :any, x86_64_linux:      "90e437fb36ce33750f955eea5a382d906e19f3e758c7b93b81554cb286b62b58"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      TOML

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-outdated", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
