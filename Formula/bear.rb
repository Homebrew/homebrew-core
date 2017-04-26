class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.4.tar.gz"
  sha256 "9ee30a034222424cda5d8c2eedccefdc2727ea8eb90ad32a32272dd3f31f3d68"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "c43f145350e67422be9d05b7b21d2ad7b811638b7b3c0ec15dcccd2f2e82fe98" => :sierra
    sha256 "093f8de0d3265e12b0671ee661beed290e03f1dc747ae4af3e3c71ca7a2fa4b1" => :el_capitan
    sha256 "30a35feae4da6ac42669b630773bba9f24561c53b95ca1c870bed83c36fe27a8" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert File.exist? "compile_commands.json"
  end
end
