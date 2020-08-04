class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  license "LGPL-2.1"

  stable do
    url "https://github.com/liblouis/liblouis/releases/download/v3.14.0/liblouis-3.14.0.tar.gz"
    sha256 "f5b25f8059dd76595aeb419b1522dda78f281a75a7c56dceaaa443f8c437306a"
    depends_on "help2man" => :build
    depends_on "pkg-config" => :build
    depends_on "python@3.8"
  end
  bottle do
    sha256 "d90fc8996fd09ba5154fb9cc597a8a588834b95511b50c589020a875ed0f4feb" => :catalina
    sha256 "ce4feb9450cb8cbbaf70f885c04ca84d4136eed237bfaa7876ef5ae22491a272" => :mojave
    sha256 "d3527a68640b4bf5f2c174299e472709e8b6c149b37882854e4aaa7efd0fc2b2" => :high_sierra
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
    system "./autogen.sh" if build.head?
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
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", force: true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", force: true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", stdin_data: "42")
    assert_equal o, "⠼⠙⠃"
  end
end
