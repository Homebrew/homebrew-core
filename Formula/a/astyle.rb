class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.21.tar.bz2"
  sha256 "2723e43bc0fb453942a394133683222fd85b1143ee6ae0b1f7b5b1db38df31cd"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78c6bf31fc047f4bbd9350b402fdf89d07309ef125669094be5f03f58d7f4b8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "798e77bc9686208deadc5af9974c434fbcc8ecc9307a5d0cda86fe25e7da8e69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0f9133209e507376ec928a8f8897bd6c113cbca455b82cd495fe837b644ef32"
    sha256 cellar: :any,                 arm64_linux:       "d374e499c097e8f16329984872d8a9597a0a8d8cf282717cce56d9c3029d4cf8"
    sha256 cellar: :any,                 x86_64_linux:      "17296480819c3e5c3a4578344dbbf1bf50024055706283358104f21a567bb47b"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
