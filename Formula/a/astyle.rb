class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.17.tar.bz2"
  sha256 "edc839b80077e60ed5786b6394d442b4eb10156ccbdd5944b4b360e125afb3e1"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18544865526fe7c53e0e38ab86daaf104ddb39d1d0f4c30add8d1d21d3ba281d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432d963169b3e2a719c2a23fa56837e0df101e4d7cfcf38f994521fb0e6a7470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64291227c7edddf30f44e4a213d60e06fda2bb0ce8682661b22ad7c527128717"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3674609be157ef6a71472748aeb01c7991fc9038304f0cfd2e5fe300e5f6b48"
    sha256 cellar: :any,                 arm64_linux:   "d6f04a3665abc89a6afc03df9a7ffbd18584044dd9b7dcde3b1ccfbc7c7e5fb7"
    sha256 cellar: :any,                 x86_64_linux:  "2fcdf255b964e8b5cf604b7d8c807e5d49901e2885ecebc6f1e6ed8e5dfc4d20"
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
           "--lineend=linux", testpath/"test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end
