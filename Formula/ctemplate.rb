class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.4.tar.gz"
  sha256 "ccc4105b3dc51c82b0f194499979be22d5a14504f741115be155bd991ee93cfa"
  license "BSD-3-Clause"
  head "https://github.com/olafvdspek/ctemplate.git"

  bottle do
    cellar :any
    sha256 "de55fe59cb142f6837d75f81c32a1430bd1df1cd3e612f2ccaa60baf4443ac4b" => :catalina
    sha256 "614ac53920b9d21fcd936bf83580168ba9bebc15df7e87cf99135ab20bf1744d" => :mojave
    sha256 "563a9a2d8c62edbd1496b4e360a625e3b484856d35edd945b364586f65c0e4e8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.8" => :build

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

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lctemplate_nothreads", "test.cpp", "-o", "test"
    system "./test"
  end
end
