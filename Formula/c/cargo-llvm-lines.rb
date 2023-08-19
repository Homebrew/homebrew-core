class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.32.tar.gz"
  sha256 "cb815a297dc32e61a2e9b9d4a129c09ec0985921e0327ede671482428d4e5a8c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "041969ccde933fa85ca34a5aadbd03b49937c01c4321c5fcadbd9171bd5494cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "978545b1c99b3939e716388f854d25fc8a02f872da77e0924bba1043ff2a39e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2077e90e15fb6d2665e046c60c3dbd087d7d17e1c3748f29bff754803d2242f"
    sha256 cellar: :any_skip_relocation, ventura:        "d0fdd42a17b4e0e9c89ba3211989e6489b4c004eb66e845d7556fb3db4d2706b"
    sha256 cellar: :any_skip_relocation, monterey:       "1fcb1e0c58030f803dd28c1e3fb1b2e5592d0f11af9427b521d0c45333fd836f"
    sha256 cellar: :any_skip_relocation, big_sur:        "29b5fd6f18b31ad492782d75a336a3e8f8e8929a6b7785ddadddd1daa2b35187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96804a779be524dc604156941af5b5b86b964ac89cca86dab7433036bfbd310c"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
