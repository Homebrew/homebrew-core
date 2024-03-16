class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.8.crate"
  sha256 "c1cb94e7d372c775b5376a75a41419fd9ecf729cc2ab6f0d99727e29a3d1ceb3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "681c1a99a7c32ff9e2bcd8c9c698500247a8d4f31d694f9c9d04035d072cd996"
    sha256 cellar: :any,                 arm64_ventura:  "482ad8e446e4fdbb25529734e7311b913c453a202ce57b0bf56be76bb209ea79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a8ec284d3cba2f18c1ea64b3dbdc517213971fb8eec6b3c0f9275e90e33a25"
    sha256 cellar: :any,                 sonoma:         "8ac48da8662c66e8ad4977a7d5f9f10d1d4f20a84f25fd6eb86544c067b373c4"
    sha256 cellar: :any,                 ventura:        "fc1273378503f57b248551bbbaa9f29e3f0ca9f8c8b690ccd4ce28a3463f9e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "80b4541d00208fc891e8bca74a2867b9015b7f2d3ca7ccf708aa1cd54f172073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6377962ff527601256153ccdd0df5371aef5e881c1557fa92fb222b36be3991c"
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
