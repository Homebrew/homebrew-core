class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.37.tar.gz"
  sha256 "cde0638cbe1e084d67cdf4341cc4abd827ca26ffda521f57777fe77b2f5defa5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9af6f9cdfa4bdd9490bf23f72509e82c8f66168aa2bc966ba4b88bc6e8f35d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "961f8f295a4b00dc7e8180c2d9eb0dd887be18dba5b52489c5de0bfc921b8401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0caac6e707be96e7f0b6b3eb7a837d0c3c2deb159d33edd53a195f49e6a018e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0989ae6be33ca26da976a1569c4354306a8bc15f26715aa60423ec29b1cc1a1"
    sha256 cellar: :any_skip_relocation, ventura:        "c14bf01e8370db4bfb4554bded9b715cde25902c5458fab0db6d29fd5b98ecdd"
    sha256 cellar: :any_skip_relocation, monterey:       "98d23e0f4fc55e57f8432a7619650be77860f8c52e627505a786df5a94b4584a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9741f8e6758553b6e42d8c8d3291f84acd3c4bddaf95d4c543e81b650fd93d3f"
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
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
