class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.12.tar.gz"
  sha256 "4841e606a2fd642524b48206f5777691d7a66afad54ddea24cb4a3d63113484b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c69877426ae36001d8945ff7283e8288af8615240e9fea506216f752e5728b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7477c0e478b44c685286fb5ee438991ba817308973f974b0105ac8f453d8f2c5"
    sha256 cellar: :any_skip_relocation, monterey:       "9975280ca8b2f0e666cc0082e3ffb95a5f20780466e3d87e1d9731c2596e2b90"
    sha256 cellar: :any_skip_relocation, big_sur:        "65a2750b5af50dc662e5015af0e86648af4258282bde5bef173edf5ee743bc8b"
    sha256 cellar: :any_skip_relocation, catalina:       "c7d2161ae1981fdab972e20cf41854a1db147dc51955bfe5f60de81fbdb14a19"
    sha256 cellar: :any_skip_relocation, mojave:         "2c964ba29b0a1d5f5c3d0bd6408a434acbe4f1f501319f8c92daf8caea219795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d3da247d169be76162f26ed9689b2d2d99131ed8c411b78def71ab0364424e"
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
