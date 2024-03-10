class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.7.crate"
  sha256 "f398701838a057c5dfe03b254edcc4a23b190c6093f8d3802f9c296a977e5f72"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f63ae65ebbf45854c15599e1f75b529e342e0a62701c651e6056c70c16a22d0"
    sha256 cellar: :any,                 arm64_ventura:  "d9311ee7707ff0ced996c11c1acb0d53b8ab1b19de44defd6228ca896cb12a34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "406431cec7e896c9f8230c50ef1dc44e46eb387654cd1e7ae31cc856045c3b63"
    sha256 cellar: :any,                 sonoma:         "2f3740c0d25079afe73f9c7597e6933e48c16a2b245154f75d9f28e38e7b62d7"
    sha256 cellar: :any,                 ventura:        "b055d1233f7748d8f95cf08f96cc7c304f7a72277037a23426c6bb456ec66ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "f08c95e786fd05db788d76fc2755fe55f95c2ef88b5fc8aa11b6af3ee2189710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1d13ffd95380764841566880b41e7deeb01328a132b6fada8e63e5c48aafbd"
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
