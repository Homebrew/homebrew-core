class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.5.39.crate"
  sha256 "60f89eb4e0a0024771ce48a0824e5a2c21853cd0cc8911957686833e40379a7d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fbce50dfd090848f064873d64db6c6da56fe7e9aaacf382603ce9c6caef5fd1f"
    sha256 cellar: :any,                 arm64_ventura:  "b58d50a85f9f6930e48ee925da5443989909814f33739610552a1ccae12621e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0748ac96dc744a847171a6575041efe67c691a805f65c3f271ac0add1b73b3cc"
    sha256 cellar: :any,                 sonoma:         "d79475785d9ef478b09d1580e29122fcd6d3dd522191d63710fd01f373fcf3f6"
    sha256 cellar: :any,                 ventura:        "85f3534f6134180f6dbbf77b342da28cf7c415a4731e9302b07b9394f36e8add"
    sha256 cellar: :any_skip_relocation, monterey:       "20cecb74d289fae102452e1561c3b9f76e00c77f5ca05a0c8ab24abb37bf0f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9ab987eb439916e5aec1ae02d7b55e415d9e0e0e3be431b8b5153969d2f93cd"
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
