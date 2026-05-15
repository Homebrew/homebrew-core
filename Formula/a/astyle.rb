class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.16.tar.bz2"
  sha256 "414e9da4cfdeeb35d8f7c170e15ef43af5fa0066c9f592a746f7071f356ecda7"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73efa4bdf93f97ca10732ae1e198cd4c75d0a395ddf347e5bf251429f9c10ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef1e260d5714b4ee6048f8ac8c817bf40bb9e6234378efbf1dbb00478a4812e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d669709df80944b3e01237691ea0f22be4cb730fa3b6a89f6d4aadcd648807"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0957ad1cee1b70077740703431b7269c961aae1be7f02fa44961c85ad3c9576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7fc9dc7b6683996c89285d0fac1ac560e1e2b8bdcfa726cfa5621d4538aa075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a1247d53c6d7704b960f0f61cd24207e8f20f1236a6ff13501f7095031eaa8"
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
