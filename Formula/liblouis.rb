class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.22.0/liblouis-3.22.0.tar.gz"
  sha256 "79bc508425822e4df2ea50ac4a648e80ef0878afcd979b655bfcac5c1766763f"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_monterey: "e769de4bbb3c436190d0d17c385b71970852081d0b09d103e0e823e7aefc9f57"
    sha256 arm64_big_sur:  "4f36aef2fa2137fec76ec8c48e70a12a0f869be962c664b691cb38f0ba918c38"
    sha256 monterey:       "3edaaeb5d262ebcbe82261b530f1673352c5758be1fce71c2c4aaba004e5e22d"
    sha256 big_sur:        "507f441db29d4922ec57910d4bd4a523a5217b36d7d55fb336425ba0ac541732"
    sha256 catalina:       "e4f9b1cd8cde982282ce2f8c2334d7723ca663e3e4e7b72c7b0389d7288bc329"
    sha256 x86_64_linux:   "da6e17924278bf881f62975b42cd482159152870bb3642efcc694b9832fcc7c3"
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
