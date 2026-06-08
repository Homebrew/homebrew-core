class C < Formula
  desc 'Compile and execute C "scripts" in one go'
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "ecfad78cb0ab56da44dcfed805f5c261ddefd6dc4a4e57eb2dcfcffa85330605"
  license "MIT"
  head "https://github.com/ryanmjacobs/c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea0ccaab4e1a14f38642b582e2ab9c5c53b3bc8a4a90e34e51f6d3eda5a15976"
  end

  def install
    bin.install "c"
  end

  test do
    (testpath/"test.c").write("int main(void){return 0;}")
    system bin/"c", testpath/"test.c"
  end
end
