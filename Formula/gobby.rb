class Gobby < Formula
  desc "Multi-platform collaborative text editor"
  homepage "https://gobby.github.io/"
  url "http://releases.0x539.de/gobby/gobby-0.5.0.tar.gz"
  sha256 "8ceb3598d27cfccdf9c9889b781c4c5c8e1731ca6beb183f5d4555644c06bd98"
  license "ISC"
  revision 8
  head "https://github.com/gobby/gobby"

  bottle do
    sha256 "5e2914adc88813352b11d1db5e69d2aa9b4612b7fb4ae05443a18b9426a0f26d" => :catalina
    sha256 "d55e74b24f3d03968afa85eff7473316e8c0816a137d82e26e24e089b42cc3b4" => :mojave
    sha256 "76ec450b768f0d27bb032cfb34e337002ee9f45a547a07c01e03b73e03413ad0" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "gtkmm3"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "libinfinity"
  depends_on "libxml++"

  # open issue since 2017-04-23, https://github.com/gobby/gobby/issues/143
  # no active release and maintenance since 2018-08-26
  disable!

  # Necessary to remove mandatory gtk-mac-integration
  # it's badly broken as it depends on an ancient version of ige-mac-integration
  # since it depends on gtk3, it doesn't even need gtk-mac-integration anymore
  # This has already been fixed upstream: gtk2 support has been dropped completely
  # and all traces of ige-mac-integration have been removed from the code
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gobby/0.5.0.patch"
    sha256 "d406603caae0a2ed6e01ec682fdd0ba5b3b23c5a731082f93b2500c95ab2f7e6"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-gtk3"
    system "make", "install"
  end

  test do
    # executable (GUI)
    system bin/"gobby-0.5", "--version"
  end
end
