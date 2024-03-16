class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.8.crate"
  sha256 "c1cb94e7d372c775b5376a75a41419fd9ecf729cc2ab6f0d99727e29a3d1ceb3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93b301485a59d5c6628baf88c2e672186cfe4d31353296fddff9cceb5f4c05b4"
    sha256 cellar: :any,                 arm64_ventura:  "b39da6427c1b9d6e64897e4e864f9869401a21d40152f50c1691800884335e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4f8b52ef9d48e68335e3bec79fc1d029ef0a51fddd7efefd9c7a57e96145db"
    sha256 cellar: :any,                 sonoma:         "59296846a61296b7249b447c7cf29fe6319f9ee2ff2346cdaa691dfd20d506b1"
    sha256 cellar: :any,                 ventura:        "cfd13fee5fb259b7e9d0c6d57aec1402d6f459b6db4afd5452747d488b35d49e"
    sha256 cellar: :any_skip_relocation, monterey:       "9274276c4a37cae9391c385885800da9c659251b0de908f3e24775b5cdc3fbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0d71d81c157b64f4d39cb2c2998b046991b8e86ef6517906fae16e90d496c2"
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
