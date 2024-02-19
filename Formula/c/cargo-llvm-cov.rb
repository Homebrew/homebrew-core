class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.5.crate"
  sha256 "17183d1d1f772d18ad79897fa14e72824403d7d0e361a0eb261de5d33e1999cf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b5e6e0be0b75a068cb0f47111d89a3e5193ac98385c1a896360aa5413545b17"
    sha256 cellar: :any,                 arm64_ventura:  "4808ff3f73b3ab809d51eed821f9bd383824e7c35b64001f540b1d899a9d5ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b090783f42810e3caa49d952c8e191760023a8c5587b5d18a1ed83f0a4e7c9c"
    sha256 cellar: :any,                 sonoma:         "f0533ba63d9198bc0d0775ae26d1b5ee691cd5f2bef94e55952f5d8a4802c673"
    sha256 cellar: :any,                 ventura:        "6acce3a10833bed5f16312cad20b2158e94e444e38e8da031ccd0f17b0397e30"
    sha256 cellar: :any_skip_relocation, monterey:       "387a81f4286479204495ceefb5b06a9ae3167b27afe5b8385ec037736ffaf81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a7323b91fefdf3fdf868eac87af8af2572fe7f57a6ad7fa5ac477c87e441e8"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "llvm"

  def install
    system "tar", "--strip-components", "1", "-xzvf", "cargo-llvm-cov-#{version}.crate" unless build.head?
    system "cargo", "install", *std_cargo_args(root: libexec)
    llvm_bin = Formula["llvm"].opt_bin
    (bin/"cargo-llvm-cov").write_env_script libexec/"bin/cargo-llvm-cov",
      LLVM_COV:      llvm_bin/"llvm-cov",
      LLVM_PROFDATA: llvm_bin/"llvm-profdata"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath/"hello_world/target/llvm-cov/html/index.html", :exist?
  end
end
