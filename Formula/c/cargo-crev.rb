class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://github.com/crev-dev/cargo-crev"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "785ed01f3352331ac4f6ecd63da5ab896a4d251678ad75b6bcf1545858a4cc82"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7715a41968d82d25241c56d134cc8c0a15b92e26ee16abfc1278769956138128"
    sha256 cellar: :any, arm64_tahoe:       "52765d78d0e19c29e71b554601533ba069e7a3ac25f4fd6ee162e4a097d2f55e"
    sha256 cellar: :any, arm64_sequoia:     "8f06b458337b3463a93a32c48b90a43dd03fa13dd13bc382837248fe1b83b345"
    sha256 cellar: :any, arm64_linux:       "76c32050e7b25b3bd79c03c20c83a204eaee1b2f09dfd574b34d29a9f28a34ee"
    sha256 cellar: :any, x86_64_linux:      "ae71b1058eb105ad9facf57463d17604b657bbc0a7b86bef7e542974d90914b9"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@4"

  # https://github.com/crev-dev/cargo-crev/pull/880
  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    url "https://github.com/crev-dev/cargo-crev/commit/974a24a1d7f77794bcc9029b5f059ba535e13340.patch?full_index=1"
    sha256 "54373e086a0070f24e3f03161a4ed1c9c78422f3471b9394cb2b57749590c4d3"
    type :unofficial
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cargo-crev")
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "crev", "config", "dir"

    [
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
