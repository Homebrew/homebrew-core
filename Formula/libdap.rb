class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://www.opendap.org/pub/source/libdap-3.20.9.tar.gz"
    sha256 "77fc93159d2c71d6ace5709babd9dec598285186aecfba358cb623be29a8e5b9"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b2e68f254825703c580a7ec38276b1591cf74899e4f2fe598f2f76133ac29343"
    sha256 arm64_big_sur:  "9c645675eb8c23e98ab5521bdbedabe07fb031a6b968e1d8d56df491f89fc960"
    sha256 monterey:       "761ab9914f8199a6eb67e2f8a4f8cab5a2ec4973da6ad84990cf13ec6feb72d7"
    sha256 big_sur:        "2bcff3fc4250d9d0c877216dce34528b558a93f82b007ce75a42498b04dc6174"
    sha256 catalina:       "90f3be6adc9ca1ca7385043f7a3e7099aed471f855dbdd38718e32e529ccfc22"
    sha256 x86_64_linux:   "9fb1bec5ecba77807cb843178b2dba742bbf58d61714040ca1da9fbdb45d09f6"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
