class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.12.tar.bz2"
  sha256 "19deb06a1ab6e5010b96c281bae350560d9789cbc896e303f3610179832fd2be"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beba21db6e36a5d95098db9538870383beb991aa79b917ff00605eccf93fc7c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ba21466e2b74f0caeacb8323c9e26a2da0b491427f2ec4cfc04e0998dcd4f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ebe593acbfd976403e387505f7542ffd5679e2d243e21aba03ba6c8f13ab1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c5fc2fdd27d3b659ac886fbc371d0c3d78a0281b5f1de21c5da8d50417dbf77"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3026d6e7c8615c30b8b948fe15751833bf67cab757387d7329e4a952f82cfb6"
    sha256 cellar: :any_skip_relocation, ventura:       "8214c647b65e4872bf7403797637a6773bdbd3e3b25e1e10671c9a5433f44e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2080fb0d16c0b19eafcaa57c6c772bfe7bcd124ec68d7b8dc5e0103f9d2435c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35bf4356d746dd9ca226830e14220749caf91305873abd3faaa07a35307a2f13"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end
