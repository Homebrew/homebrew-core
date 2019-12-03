class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"

  stable do
    url "https://github.com/liblouis/liblouis/releases/download/v3.12.0/liblouis-3.12.0.tar.gz"
    sha256 "87d9bad6d75916270bad14bb22fa5f487c7edee4774878c04bef82833bc9467d"
    depends_on "help2man" => :build
    depends_on "pkg-config" => :build
    depends_on "python"
  end
  bottle do
    sha256 "8a1f8644c50e6fae5921e0310f2d947d125fb955620bb5ac43db4ac96d64994c" => :catalina
    sha256 "f57dd551d0a14fec1052d4427b2c77a685e396ec6d7759941126ccf16921bb3c" => :mojave
    sha256 "03c686d2a9d9d9f8bea700fe92e1473dc901d8c01fa669f1a7b30d3cad41df0e" => :high_sierra
  end

  head do
    url "https://github.com/liblouis/liblouis.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "python"
  end

  def install
    if build.head?
      system "./autogen.sh"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    cd "python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
    mkdir "#{prefix}/tools"
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", :force => true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", :force => true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", :stdin_data=>"42")
    assert_equal o, "⠼⠙⠃"
  end
end
