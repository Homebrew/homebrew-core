class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.6.tar.bz2"
  sha256 "6d0ad0405048e2ec90566a8be4cc0b7f0e2a8d96482e24090b502d4e9fa46c42"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33710961eefb51df4a78511594e59e3566329daa69a95acfb9d74bbfad205f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac2f1da1a0cb7f2685f8887190c42db41eb47b3740fce14250e59f3fdcd2fc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a926dfb3377df63ae4d7759c9d638a89bd818bfa82afae63e446db9175facdff"
    sha256 cellar: :any_skip_relocation, ventura:        "b3b7f7f89797ae217319582e8d3d5869175ab777729b063044ee8790ef8a41ab"
    sha256 cellar: :any_skip_relocation, monterey:       "c22fcdbb5a53daaf712a2822a8c1f5b4ddbed2bbfb1cc6d5b65e6fc080109e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "d65f4afc2c0e5dc1f1b2982f965267d5db3c669eb1bc4e508b6f2cb7b4962204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81a210c243e5763f836876e31b2653fcbd0c850dc4379a4b440dfeaf797abba"
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
