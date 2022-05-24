class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.4.tar.gz"
  sha256 "ccc4105b3dc51c82b0f194499979be22d5a14504f741115be155bd991ee93cfa"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/olafvdspek/ctemplate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "2af8837c0e6f6cb3405008c71795fcc3def16818aa2512365ec027cb3ad4b48e"
    sha256 cellar: :any,                 arm64_big_sur:  "d9b6bdf4a7d13079ea3eb55d1cae8307513a8aaa7d782eda9333a3a96ff45523"
    sha256 cellar: :any,                 monterey:       "407f8bdf5dea727de91e5436cab5b0e271fdd935806aa985d38d5ed4c2db57e9"
    sha256 cellar: :any,                 big_sur:        "3e4c9c7028cf8037cc61000e24d25fd34bc8741a863b440653c087908ff33169"
    sha256 cellar: :any,                 catalina:       "9451278bdf27133395761b18b00e88fb5ac3765bb1b5a0da7acb88a671ef7977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef9050d0aa26b1a38f26df4e71d084ef439f5f26600f9defd8ce8b5de2221c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

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

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lctemplate_nothreads", "test.cpp", "-o", "test"
    system "./test"
  end
end
