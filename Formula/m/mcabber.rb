class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.2.tar.bz2"
  sha256 "c4a1413be37434b6ba7d577d94afb362ce89e2dc5c6384b4fa55c3e7992a3160"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?mcabber[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "5a3fd194c38f6e2cdde387ac0d822bb4d44735e3a5dee9e04bd847cff9febaf7"
    sha256 arm64_sequoia: "ecad9a3ee398b3a8d3da0c3a6f70ce3bbd6d8b7f0e56982c534858deeb7f93f3"
    sha256 arm64_sonoma:  "df43d005dea2bc2e1ad875453efff00618a535da2dc69041f65bda297aaff7e1"
    sha256 arm64_ventura: "53fa4715f224ba5b3c89b8e3f4894055a45a99897ddde8534f3344ac654341c8"
    sha256 sonoma:        "91739babcca8744a2b366cdfe13a3504bb55b38531301c5ed131a68aa761e7ae"
    sha256 ventura:       "82b5dd6349e6e36c3cd053aaf4cac15c2e421a5c599011bf6fc80006f4a412ee"
    sha256 arm64_linux:   "80babf982f8b324a1b5930c44faf244e4b342fb3e14fb0a4f8eed724b0578446"
    sha256 x86_64_linux:  "fb62852c31174e4df62f12848a3a3cb942a7c0d86dd77f3ca0643d75ba088d97"
  end

  head do
    url "https://mcabber.com/hg/", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "loudmouth"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libassuan"
    depends_on "libgpg-error"
  end

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--enable-otr", *std_configure_args
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
    system bin/"mcabber", "-V"
  end
end
