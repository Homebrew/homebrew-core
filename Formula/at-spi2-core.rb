class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.18/at-spi2-core-2.18.3.tar.xz"
  sha256 "ada26add94155f97d0f601a20cb7a0e3fd3ba1588c3520b7288316494027d629"
  revision 1

  bottle do
    sha256 "e6740e78c2539493412d8c904d30a9cc5149d054019d3376b7c313f674d8f798" => :el_capitan
    sha256 "bec02510d1c9b936eb8949cdfae0c7d6d98c61903a60c86224c31faef601da47" => :yosemite
    sha256 "5bae032aa34888e236c7c24b2da29fc4c289b5a6372cbeab360180184bb666ce" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"
  depends_on :x11
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
