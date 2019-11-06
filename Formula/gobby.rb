class Gobby < Formula
  desc "Multi-platform collaborative text editor"
  homepage "https://gobby.github.io/"
  url "http://releases.0x539.de/gobby/gobby-0.5.0.tar.gz"
  sha256 "8ceb3598d27cfccdf9c9889b781c4c5c8e1731ca6beb183f5d4555644c06bd98"
  revision 7
  head "https://github.com/gobby/gobby"

  bottle do
    sha256 "7c07581eadd99f56234659ecfb77b710a01bda15a549e191f7b85fd28cea9a72" => :catalina
    sha256 "18ff50e9a89c3adf2b00420158fe03a2aff057bd7200939efdec274c80490fa6" => :mojave
    sha256 "a705fb9ad205268ff01a4cb23dce91f04dee41720f5ed7276106ac76cdb304c0" => :high_sierra
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
