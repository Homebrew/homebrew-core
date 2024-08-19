class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/refs/tags/0.4.39.tar.gz"
  sha256 "34b2b308a4d24247d75b19ef5e5e05d9f69e49e4c93958b45152aed7ad49ed85"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f9c06ff5a8ae5843a55d63332ace4490748a31cac7e8fb758133e0f43b13461"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b117ba3261efc349bea91b29642abea1ecfaed7a2de2774daeacdacfe3058134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e0c2fe08b98a9d30f8f54c015fb5a3c477cf0b333558043b198cc309e283d28"
    sha256 cellar: :any_skip_relocation, sonoma:         "01dc30e345cdccc0de17c323c01584f72bea99905a910a71fd7bd054445a36dd"
    sha256 cellar: :any_skip_relocation, ventura:        "53f73081e30ccd6272642527456fa45cb8d96545da30d651f85fc5bc757b1a6e"
    sha256 cellar: :any_skip_relocation, monterey:       "42cb0d0ebf18f476b9f65f44a881ff2850604d2485d7c5a7f1f4752ab55359f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63fc50e0b61320ff46b17d1535a15ba768bc39c9de9b72c7b8ff2e58fc1ced6a"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
