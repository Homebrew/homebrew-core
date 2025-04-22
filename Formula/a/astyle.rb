class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.8.tar.bz2"
  sha256 "5af8ae7a05c5e616dd1f84d758b4909c2d2ecfc179f883fd104d223f34cc6dff"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39ab1f295367377a4db66dab4cde2867181a8374c8f90060f00d2f545ef408c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac24b65e3a76d092eef8c8b93c9328536bbce54d461e2fc627a5ae466253a881"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9431331e2a6c5fedcf82b1c043cc127ca81d729bc4b965f84f6da933a7e4b6a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3019431176432845fd8795db74102cdf88b63dd13b20111f1acf3f884af3a5ee"
    sha256 cellar: :any_skip_relocation, ventura:       "2c2c0b641450453a9e4d15aa6e929b9c5183b05001f848c321ca923b20b68dca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1398b917d1d63a5846c0cde6cfa51a55c0034abad90aadb5f458d770533dd5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3764cb4ea5705eff8f3e8095ad33faefd3a78d4368d0ab0d1222b7095da7060a"
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
