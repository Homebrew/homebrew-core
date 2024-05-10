class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.15.tar.bz2"
  sha256 "0504c733bbfe96688b66c107b6df3fa05263defabb23858e42c44ba554586e6b"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c22207e419f58a2ab1f93b3de4019b979a0438fd18312e5c9c02149499ef0fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "481c4b49c19e8305e222a083b9e868b68f454a48d4d6734cbb3bbee7005d8a1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4326d97d3c27d43641dccbf1704c5b98b09666014ef33782a2ca376d1bc09e4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ea3a2d36ab3f9e04b524bd8fc259d194307cadb651b4c69102418bf5c252643"
    sha256 cellar: :any_skip_relocation, ventura:        "11909d02d10d61c52ac38cca7936f747540f860b65aae8efc36c407e01d6b616"
    sha256 cellar: :any_skip_relocation, monterey:       "0086a876b930f261b6f4c2f82592c51a2adbc4bd272226dd5c21ff834c3b9b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf337b63f001740c08ce516aa038faebed74070fee115caef0681dfda7fe0669"
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
