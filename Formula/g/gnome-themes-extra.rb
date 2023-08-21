class GnomeThemesExtra < Formula
  desc "Extra themes for the GNOME desktop environment"
  homepage "https://gitlab.gnome.org/GNOME/gnome-themes-extra"
  url "https://download.gnome.org/sources/gnome-themes-extra/3.28/gnome-themes-extra-3.28.tar.xz"
  sha256 "7c4ba0bff001f06d8983cfc105adaac42df1d1267a2591798a780bac557a5819"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34d4d0a58cbc2d46e00628d61d1eae314393c39439a7324096e7b5168e6327c3"
    sha256 cellar: :any,                 arm64_monterey: "dbba4ae58f0979a6315ea273516bde29caee4b4e9ea2242db68c76b24b2be335"
    sha256 cellar: :any,                 arm64_big_sur:  "594262977d1082f945db69fe5d76762669c124fc58d7ed183e293ee64ee672c1"
    sha256 cellar: :any,                 ventura:        "2ba89f804c8abd86fc4b517171807fd7f2e1cd18b57fdb4b501a6ef85641b793"
    sha256 cellar: :any,                 monterey:       "16b03f35efd37b1e25a5f69a3c83591f3ee678d832051b157d9c9e5069f99d4f"
    sha256 cellar: :any,                 big_sur:        "bce14cf1e42eb6e0748174bd3b41831637f0b9c1db4a3593a487d6582ba5e8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d449ba26c4cd7191eb52c1ad0ed4b805ae85345741566faac662c6fa3e5390"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-gtk3-engine"
    system "make", "install"
  end

  test do
    assert_predicate share/"icons/HighContrast/scalable/actions/document-open-recent.svg", :exist?
    assert_predicate lib/"gtk-2.0/2.10.0/engines/libadwaita.so", :exist?
  end
end
