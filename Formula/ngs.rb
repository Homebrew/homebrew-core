class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.10.tar.gz"
  sha256 "361a36614a56bd7cb2cb0f4aa16addfefde478f9d2cbc1838eee3969262868c2"
  license "GPL-3.0"
  head "https://github.com/ngs-lang/ngs.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c6b6e9a1c709cbac99dcbafe09153e361a136e4fff3a42ddb6e0d1c8f01ef7ed" => :big_sur
    sha256 "23c81230e132df4135226aad98f52efc9e3dbe0c3a5af6832f687278b92f7ace" => :catalina
    sha256 "ca696417660b80cb36e248021723b5ec200f5c986567b69eaaa4e063c00e8989" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    share.install prefix/"man"
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
