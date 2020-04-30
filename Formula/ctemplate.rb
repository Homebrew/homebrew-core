class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.4.tar.gz"
  sha256 "ccc4105b3dc51c82b0f194499979be22d5a14504f741115be155bd991ee93cfa"
  head "https://github.com/olafvdspek/ctemplate.git"

  bottle do
    cellar :any
    sha256 "5182660efd56f221c6fa002ec0d6f9e56de53c7518a6dadd2d634e298f1e6bea" => :catalina
    sha256 "0f0dd5a902d31e3ff1e6868b425e4aeb9ec9d094337fea48f85cad7b7e0d747f" => :mojave
    sha256 "6cddb070bbc9b662305513c142119cb83fac09d1c1579b925f6f2bbddb0773fe" => :high_sierra
    sha256 "f2bbb674557034e487ad218f871145c9f27b02b908e10b2fd15f457c960191e0" => :sierra
    sha256 "3cb0314574a76b022e365c293f50eff604def9a9171b45c4e3af1c56f5310927" => :el_capitan
    sha256 "f405ef2681e4e0aff1a034226733e4466d6f916ae540fa7a3a52e3d94f529f26" => :yosemite
    sha256 "335fb8f9b6ac20aeb09efba90dcdba941b7c0cef2571dcb50fb2040f515386c7" => :mavericks
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
