class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.5.tar.bz2"
  sha256 "defc1cb7bfa863bec470e836c257439a1199ca2c8b13a652a327fd78c8f5923c"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e406f60574941a45d5fa0f374e1ceb17db52a5dc35200bdea9ddcbf39661812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eee9e970c7a36602f0c899f1d0c6b39f7c562174f86d1efb4c642fb54621d2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45124b3d7e05ebf88f12c149fdd4cd5af63da96ba4bbd8e4cc875b1afcaa84f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ac6b8486aa55506784d5c88a5c1c241f9887f065bfe33bbdd4ef5dab4f8bdb9"
    sha256 cellar: :any_skip_relocation, ventura:        "b1bee83ed7e0d8bb5aecdb70c7cc85a5c4e9ce3b50ee2716ef853bcfa5a0aa92"
    sha256 cellar: :any_skip_relocation, monterey:       "6c88fb96b3c0c5bac06a74b719ee037650f4b9a6952a36bf395827ee10aa2ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1108137b2b0329e04a3ca7859496bb7ee620b76b3d3fb733b1e2c8cf859c42de"
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
