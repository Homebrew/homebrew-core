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
    sha256 "878205190dfe42d286b32c9d5a3427c902c2ba8236ff8c189493da3b6f131fe0" => :catalina
    sha256 "84c7e03f748a9cec9c40bca8298a26ed880e6981673d328f78c375d8c55c2c66" => :mojave
    sha256 "b985d064857cd05df36bebda78a13e105230907fe7380167edf572f5d62a7756" => :high_sierra
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
