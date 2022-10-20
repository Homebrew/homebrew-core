class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.4.tar.gz"
  sha256 "ccc4105b3dc51c82b0f194499979be22d5a14504f741115be155bd991ee93cfa"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/olafvdspek/ctemplate.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "fc6f772b98ecb4ac32af2525fb14e00e78d3869965b0b2cef4e9052ae7920f15"
    sha256 cellar: :any,                 arm64_big_sur:  "4857a36c04ea358a584ccc4bf814cf14ea132f719044982bba4295ca3bee54ce"
    sha256 cellar: :any,                 monterey:       "1186d9da15756058d715022d75e654ddf8c30573f79490a6d945ba3501e651d9"
    sha256 cellar: :any,                 big_sur:        "5e2edf873c559dbe6fee25404fb5f73dd0237358d553384c65284db99c1e1aeb"
    sha256 cellar: :any,                 catalina:       "03716a690ca0715b4832e3cbc95441a3e9765c36b277a33f85ac7806469d9928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0782447bd58da47c13e2c3fc367e616addbe434c4fef762daea8bf6ea0b85626"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <ctemplate/template.h>
      int main(int argc, char** argv) {
        ctemplate::TemplateDictionary dict("example");
        dict.SetValue("NAME", "Jane Doe");
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lctemplate_nothreads", "-o", "test"
    system "./test"
  end
end
