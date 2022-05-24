class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.21.0/liblouis-3.21.0.tar.gz"
  sha256 "6d7f4ed09d4dd0fafbc22b256632a232575cfa764d4bfd86b73fe0529a81d449"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_monterey: "edaa66d2c114d467b4252be12f0dadff048cf217291278ba0389b2c66bd8f7f7"
    sha256 arm64_big_sur:  "005f73c85caeebce3ece98318ed9cd011f8c7402fbc73fec9ea7a9fa1dfc7df6"
    sha256 monterey:       "c9deea8618a1fbe77a00c2bbbb09bae690249e18e0099016756ca36ee985ce8d"
    sha256 big_sur:        "84870b729313a627a984a0c844f18da7d8548c1ea4eb7589b37b1828f9f77557"
    sha256 catalina:       "2b05f8113124d98e8bf35943508ca1fe2aa3fc9f411849212bef04c538f13136"
    sha256 x86_64_linux:   "782c6f0b15b6ea597c94d8b97ddba3b35da0ba220f949fee630186d30cdd41f7"
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
