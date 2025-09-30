class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/refs/tags/ctemplate-2.4.tar.gz"
  sha256 "ccc4105b3dc51c82b0f194499979be22d5a14504f741115be155bd991ee93cfa"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/olafvdspek/ctemplate.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:    "d6900c980a0644c4e4e8d8884d7393e6bf9fb28108901ad207206d93c5ff0508"
    sha256 cellar: :any,                 arm64_sequoia:  "acd3dba90331797c66b476e02edfb172fc67566fa46866d4b6c72605bb331030"
    sha256 cellar: :any,                 arm64_sonoma:   "da3b3f971024e8235955c5e6c2c3b0ae8626e229f2e5e26d5edceaf5fe10e6c0"
    sha256 cellar: :any,                 arm64_ventura:  "ee9935e535f7fc5ad36e78a17cdfa370dd804442065fb9d71f42939042b9a239"
    sha256 cellar: :any,                 arm64_monterey: "60926618dc8939dee2953a3eed541ffbcda70ae70ea9e4811de4c635f351c3dc"
    sha256 cellar: :any,                 arm64_big_sur:  "229589ee690294f135322334b902cacb32c86b9be7775320920300f8716d2a2a"
    sha256 cellar: :any,                 sonoma:         "182d6a82a8d4b2a529965002e528c53b0d6449ecbd2d5f83388dbc79132ef31d"
    sha256 cellar: :any,                 ventura:        "8395eba52adc92de5ec11316fd65082dba1f5c934750cd86d7ec68ab7c40251d"
    sha256 cellar: :any,                 monterey:       "3403981879581767866598b52b148046e46362102620c6220a06464add516197"
    sha256 cellar: :any,                 big_sur:        "d47aa3297f5e44511790bb0fb1bf4e7eb5d37c599b9c9b661133d68f821b7048"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d8952fd11178e7d1378d3be330d5cb5d393d15837544f375700badd9044d5d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "376a70935eec4f3f5965bcd0b39603f25459b8995d12d124c3ab10184e15f3ae"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "python" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <ctemplate/template.h>
      int main(int argc, char** argv) {
        ctemplate::TemplateDictionary dict("example");
        dict.SetValue("NAME", "Jane Doe");
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lctemplate_nothreads", "-o", "test"
    system "./test"
  end
end
