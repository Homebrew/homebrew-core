class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.28.tar.bz2"
  sha256 "816bbd1e3c41b0dc606ae10fdd5492253030fc5506903d61f3575bff9178b7d4"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    manifest_sha256 "7b583cf2cb2f81d56a8713a48f6d889b5d8848504002452f4188581b1c05469f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82d5bae4863e49689f66077b46da6f848aff3858cb2537b4e4288015f3f832cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bb6104cdf38f437d033574882004e83d6e9f9455af5b3e7d76f8a188f0c1bc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d061043cb040271f73b85550c1f49cef9a5ae44368f3e64ba80486389920199f"
    sha256 cellar: :any,                 arm64_linux:       "ea5d647cbbae2634ab9f3bb46701155bcc89d73ea54bad4f237b4b0f0bd07c1b"
    sha256 cellar: :any,                 x86_64_linux:      "9da16dfbbb35eff3d7f3129f5c6c5122d15462bc518d7ae8e5843d9bbd4d8e77"
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
