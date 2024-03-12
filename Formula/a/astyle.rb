class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.13.tar.bz2"
  sha256 "78a610abd39e94e0f913e9ee5cda1e85bb62cd633553decb9e00d3d9201019ce"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ed1c80387fabda9f2680c605f6a27c5c25819d9740a4031c7b97071c5f6563e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a9530edb4f8d30310eceb946f16bea3bc40cb5c5476bfbaee1f0a8f83c5928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22421f13c6275d0a1d307e48aa5ad569ce736c747d498df9b187827c5fa6b0e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea3ca1f0a1dcf565e3d940399e0a940c6ef9ef74c184cafbc2d5738c6dd32abc"
    sha256 cellar: :any_skip_relocation, ventura:        "30129c2d50591249f7c7b7175060cb41a55cf785a59f6d12fe01c7298b6f482b"
    sha256 cellar: :any_skip_relocation, monterey:       "f97cd7758ada6ebaf3816f146f1318d7a9f3555c122e17ba02c1e7796b3fcf78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a214f29f23dd152937f6cfc4289f652478d83697a609db43ed7f4459a6bb251"
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/gcc/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
