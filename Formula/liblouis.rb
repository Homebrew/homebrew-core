class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.23.0/liblouis-3.23.0.tar.gz"
  sha256 "706fa0888a530f3c16b55c6ce0f085b25472c7f4e7047400f9df07cffbc71cfb"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_monterey: "35ec18e4d8b2ed9b920870221df7a212757efb7172048d0cea6915e9dfc41e66"
    sha256 arm64_big_sur:  "789a093d461f43cbd06b60ddfd8b31fb7c23bcdb35ab45f6c47db29ee51a9b18"
    sha256 monterey:       "ba742a630aadc86182f4c6105992998cc12ccebf8101399ac713b14e92e1a898"
    sha256 big_sur:        "b597e9935dbc90cc634b05ed6146569010c36de72b8e0939f31498b6d9b0d93e"
    sha256 catalina:       "956ef790b2c129ecb8456746fc7ffed009ecf48aab9e2b78661a70e60e59a1f4"
    sha256 x86_64_linux:   "2eca52673f20591110ed7fe5cadf8a2079bb767fc71da3b5526e569f2893afc9"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    python3 = "python3.10"
    cd "python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
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
