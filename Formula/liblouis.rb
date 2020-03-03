class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"

  stable do
    url "https://github.com/liblouis/liblouis/releases/download/v3.13.0/liblouis-3.13.0.tar.gz"
    sha256 "2803b89a2bff9f02032125fa7b7d0a204a60d8d14f232242344b5f09535e9a01"
    depends_on "help2man" => :build
    depends_on "pkg-config" => :build
    depends_on "python@3.8"
  end
  bottle do
    sha256 "c69d1490078b75e5cbcf5d4847f308091b5e106120c89c4c8ef82ec71b3267a1" => :catalina
    sha256 "8e5dfc4e26c506def055cb0b798cfcfa1ec806fb6957ca7e67bc54613de18b7e" => :mojave
    sha256 "f1874462cb3354139a37226322504e2398bf2c60da32619ba578b325c542839b" => :high_sierra
  end

  head do
    url "https://github.com/liblouis/liblouis.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "python@3.8"
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
