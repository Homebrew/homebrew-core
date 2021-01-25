class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.2.tar.bz2"
  sha256 "c4a1413be37434b6ba7d577d94afb362ce89e2dc5c6384b4fa55c3e7992a3160"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "639edfef4ad26bdaea6a714b18acbda1d4d240f658ee8813b9b49f17f85952c4" => :big_sur
    sha256 "b9660212f5a994bd663e5795d9f707da933f95b8aad23bf11f5e724c2e59a1ef" => :arm64_big_sur
    sha256 "f5296e7fffbc0702dcce5794e2f47c77a998f002b0852416c8411ac5ad44b31e" => :catalina
    sha256 "301d1883a89bcf494b5ab8c2c6dc4f267b29124d479d47483f562e8c3739d531" => :mojave
    sha256 "73d4da3e1e562308e3d4a3b3318f2b5de951d50a44eec9115780170f282022b6" => :high_sierra
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
