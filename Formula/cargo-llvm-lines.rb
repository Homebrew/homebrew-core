class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.24.tar.gz"
  sha256 "d9418731de2d5bb5c14b315fbdc25b40833ab31b9b523e62bbe60ad6851d9e44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91cc1c54ca1b3efd4457dd27389ea2c0dfc29d90c5dbe3ad4585ed2acc8f15e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81a615d92a7a18a1ee827eb2c102cabb273ba7c362137f0689786428efcff6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ef9f9f912ece84b63cf38247693d796ae070b0b9d7b217305a9669533806ace"
    sha256 cellar: :any_skip_relocation, ventura:        "e420f777069a7e03758a378edb6e18779a85e4ecb3bc9a21563e18d6e276c9ab"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2aaf9affecd25431c347bde7664e413499ed0bd6be3cd2ecbc27a70887fd9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "620cd57af885ead60e13eb1411c69f7eb216db2b5060d976386504431226a9fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee31940ef00144a8734380a2a8e0711d650a9882fc5e8e95e87a213ae58489c"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
