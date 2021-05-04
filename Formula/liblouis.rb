class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.17.0/liblouis-3.17.0.tar.gz"
  sha256 "78c71476467850935d145010c8fcb26b513df1843505b3eb4c41888541a0113d"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_big_sur: "d5e6cdaf72fe18b14d9e455551b94e3a722eec87c4c528435c5d6b407ae0775e"
    sha256 big_sur:       "8c670c32218b3905855ae5c5c40186013f4ad5dea16a2207d3ae56e2ac91a352"
    sha256 catalina:      "ca3b445707462217ea870829f457ca043de82ecb02f2b99302811f8b6831ee31"
    sha256 mojave:        "0334ee43e9a3e443cdd8531a5923535618353cf2e798641bc200b20db6e8efd4"
  end

  head do
    url "https://github.com/liblouis/liblouis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

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
