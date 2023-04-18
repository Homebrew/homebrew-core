class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.2.tar.bz2"
  sha256 "c4a1413be37434b6ba7d577d94afb362ce89e2dc5c6384b4fa55c3e7992a3160"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mcabber[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9b70cf1483eede96a3c5b8df075a0e2cc92bf4ab3d84c83b8cf017b6b0c53677"
    sha256 arm64_monterey: "e7537262f19fcd123302a9a97d1e22af75f61881dff731375abc421291eb40eb"
    sha256 arm64_big_sur:  "b9660212f5a994bd663e5795d9f707da933f95b8aad23bf11f5e724c2e59a1ef"
    sha256 ventura:        "0f7cf3a039d23f52158294751d3488ba744f3489f1bb57d256f81cd48e6f0166"
    sha256 monterey:       "0f50f2e71d3afcd45bf61301a9695e4ac58bf3fc7ec13c7d6769c6482f60ba51"
    sha256 big_sur:        "639edfef4ad26bdaea6a714b18acbda1d4d240f658ee8813b9b49f17f85952c4"
    sha256 catalina:       "f5296e7fffbc0702dcce5794e2f47c77a998f002b0852416c8411ac5ad44b31e"
    sha256 mojave:         "301d1883a89bcf494b5ab8c2c6dc4f267b29124d479d47483f562e8c3739d531"
    sha256 high_sierra:    "73d4da3e1e562308e3d4a3b3318f2b5de951d50a44eec9115780170f282022b6"
    sha256 x86_64_linux:   "7e2642576b5ae1c8a05f0dc894fd9775b6b941f2a1dcae6cb8d7a0840d744dd9"
  end

  head do
    url "https://mcabber.com/hg/", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "loudmouth"

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-otr"
    system "make", "install"

    pkgshare.install %w[mcabberrc.example contrib]
  end

  def caveats
    <<~EOS
      A configuration file is necessary to start mcabber.  The template is here:
        #{opt_pkgshare}/mcabberrc.example
      And there is a Getting Started Guide you will need to setup Mcabber:
        https://wiki.mcabber.com/#index2h1
    EOS
  end

  test do
    system "#{bin}/mcabber", "-V"
  end
end
