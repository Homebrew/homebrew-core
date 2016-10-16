class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.0.tar.gz"
  sha256 "783be8aa6eab7192fc211f00adac136b21e580ea52d9c07128312a9609939668"

  bottle do
    sha256 "f822fb49ab3e57dc2c0e155ea23f93c0d8f8e230a5b6e7f41401368ef9cde23d" => :sierra
    sha256 "266839844245169363cbe2f8a4e09023adef02d529ded253aa5bf30c8607a473" => :el_capitan
    sha256 "17ceae0ada23ce3686e534ad7a3644348105805dc1f3da570cb6c08b749a41a9" => :yosemite
  end

  head do
    url "https://github.com/boothj5/profanity.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"
  depends_on "libstrophe"
  depends_on "readline"
  depends_on "glib"
  depends_on "openssl"
  depends_on "gnutls"
  depends_on "libotr" => :recommended
  depends_on "gpgme" => :recommended
  depends_on "terminal-notifier" => :optional

  def install
    if build.head?
      # Prevent "configure.ac:87: error: possibly undefined macro: AC_MSG_ERROR"
      # Regression due to https://github.com/boothj5/profanity/commit/c908f37
      # Reported 16 Oct 2016 https://github.com/boothj5/profanity/issues/870
      inreplace "configure.ac", /^ACX_PTHREAD.*/, "ACX_PTHREAD"

      system "./bootstrap.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-python-plugins",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "profanity", "-v"
  end
end
