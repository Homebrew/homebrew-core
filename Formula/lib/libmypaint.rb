class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.6.1/libmypaint-1.6.1.tar.xz"
  sha256 "741754f293f6b7668f941506da07cd7725629a793108bb31633fb6c3eae5315f"
  license "ISC"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "11d123c05be7148acf8a9e8e99b84c4734252dd3085a03e4d9ed39616d5ece02"
    sha256 cellar: :any,                 arm64_sequoia:  "ada0de7fc29d5634da50e9a9dd05858fdb5fc839f6cfefb8dda3977ab7e9dd8c"
    sha256 cellar: :any,                 arm64_sonoma:   "bd3ed49871a7e59ee4731520d6d3852c7f53a4565f125153b13aa556998931fd"
    sha256 cellar: :any,                 arm64_ventura:  "45f120eb85a644dae61e2bcf2683256dc3cae8531fa59d339e07ff9a3ba1f135"
    sha256 cellar: :any,                 arm64_monterey: "b481fb4e3ed5cb542d1ef073a5852a0a65361f0825051302ccdd6bc224901d90"
    sha256 cellar: :any,                 arm64_big_sur:  "4f5f706833fb183d4ad43a0b065b2b767a7787e7963eabced95016bd04ffdd12"
    sha256 cellar: :any,                 sonoma:         "e9f2d85eadf239650155f9c87128808ef1c519426626e96d5401cf4628e33833"
    sha256 cellar: :any,                 ventura:        "4a895f28ea58e5415711bf7f3a415f639a958354992acd5a1ffd7719417fd5e9"
    sha256 cellar: :any,                 monterey:       "30623690f18dafe72d96daad871d4f7018ab3e89970ebdeda2fbf2d56c781c68"
    sha256 cellar: :any,                 big_sur:        "65d3c8c494c5e3a454526e4254c4f4c1a1883ca1e99c2dcb09c2abdff141d72a"
    sha256 cellar: :any,                 catalina:       "699014970a67055822e7ee2abc92c4ea2b45e51bcd58cfa01cb24c2ed08f6a2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3682eee52437a073b7ae1400df5ae48e4779815035f785118eb22ea571873c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6114302a8ff4e54cd64388fb0968dbb1fa4ab546bb9d2bbca786da787ec3bf62"
  end

  depends_on "gettext" => :build # for intltool
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--disable-introspection",
                          "--without-glib",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mypaint-brush.h>
      int main() {
        MyPaintBrush *brush = mypaint_brush_new();
        mypaint_brush_unref(brush);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/libmypaint", "-L#{lib}", "-lmypaint", "-o", "test"
    system "./test"
  end
end
