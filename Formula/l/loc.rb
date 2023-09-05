class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.4.1.tar.gz"
  sha256 "1e8403fd9a3832007f28fb389593cd6a572f719cd95d85619e7bbcf3dbea18e5"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62bf06390749dffb96ea6219f9d578dcf9b95ef774a5a6b1eaa4f8bc3dda143b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "668081ed1d522d9eb49322dac5986bad986db29732cbe42bea12e4276044e37a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f44244fb86c35bd48654f2a517ecb8550a8d291baf8919f602fd88f50b15677"
    sha256 cellar: :any_skip_relocation, ventura:        "40c3ca943d6c518203f669d6597945f4019eb87ee0ec2e42c158ae67157b6083"
    sha256 cellar: :any_skip_relocation, monterey:       "8d372339b2ef67c179fcf00d33e167715dd41c729b7a50fd6026e32a5529338b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3fa9372c95f88ca42e456d2f9c451cca28c4e894afd9257fc4069215b74d8a4"
    sha256 cellar: :any_skip_relocation, catalina:       "d87bc0b8b2122f5c9a03b98ab759283882d2fb898009668d0e6f79d22cc3c4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f463ece47552bb4e58ffe4c4ff6e62dae3b57fb3b9a1e3fad3ea728b07bc660f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      int main() {
        println("Hello World");
        return 0;
      }
    EOS
    system bin/"loc", "test.cpp"
  end
end
