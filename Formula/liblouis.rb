class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.21.0/liblouis-3.21.0.tar.gz"
  sha256 "6d7f4ed09d4dd0fafbc22b256632a232575cfa764d4bfd86b73fe0529a81d449"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_monterey: "00c082f554f504af6fd9924ea39bcb66ab922d36acf4011484b0c5949f5337c1"
    sha256 arm64_big_sur:  "f6b7e820120dea41c87e41ed697e008cec82b571f5b365eca5714772e8e48dcd"
    sha256 monterey:       "d39f5c6de0b5fbffdcdfa252e3aa24249a06f964cb6bc76ab2b693fde5fd13c0"
    sha256 big_sur:        "51c4637215b46c332d3d73e91df48c951919fb88e22172272c388466bf96ea26"
    sha256 catalina:       "f127cdb0b35a49ff1259f2ef4e21c03bdb0937892bb90998938ea7951fd081a2"
    sha256 x86_64_linux:   "e63216554b01141867847e13767fa7db5b91e290d4f510a9229e561707bbe119"
  end

  head do
    url "https://github.com/liblouis/liblouis.git"

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
    cd "python" do
      system "python3", *Language::Python.setup_install_args(prefix),
                        "--install-lib=#{prefix/Language::Python.site_packages("python3")}"
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
