class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.20.crate"
  sha256 "32bf5c240cd0bf9946a07ef0dc6b9ecf64c9766f4726031f3e146a4cba09e10e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2ed4261ffd72ff435553045d0d99a064c6f41f37329456739ab0ba033cf58d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "777c98379b76f644ee8cbccbaa7a021c3a075f027143e2983d8adc16887f7b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7608ad1e7156661c3674a1ace394a8fff89572b4ae5dbb7858014b20a93b0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6032360c8680489012b37c41772304aaf539880fb52a7827ee3d16a2db658a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94a3c1dfca3dda8981d87575845b0d26b74db741a6781c3c0ace3a4945d3099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f16dee45df2dfd8ca401c57c5a69e117028be076615e331f8540cf863f34c8c5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end
