class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.12.0/qalculate-gtk-5.12.0.tar.gz"
  sha256 "4225eacefc30354f867dc14b7974efe8e8fcef031117def1098db652e1ad48b7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "c48c6662d07632c2cbd020b90dbdb5cae6a608f67799f068683682eaa0d653a6"
    sha256 arm64_sequoia: "49a98853802de0f50f5c672e1400f1240746ca87903077142d9f3d7c48fce50b"
    sha256 arm64_sonoma:  "55f145a9c07fb07ed82bcaa04051392d14995e2ed571799b41954ca410db15b4"
    sha256 sonoma:        "39a1d194d288a573e09748b0134c40e23597036301d5a2e9c407c6485cf445ed"
    sha256 arm64_linux:   "506bd30291b9e1ae7fa9b0fd0e8a19f2e8528debb61a62f649db09fa23ceb5bc"
    sha256 x86_64_linux:  "fb844ad9e727795a5dac7f004a79ea5c68fbd4e00631c628c156d49aecebde2e"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "gtk-mac-integration"
    depends_on "harfbuzz"
  end

  def install
    if OS.mac?
      ENV.append_to_cflags "-I#{formula_opt_include("gtk-mac-integration")/"gtkmacintegration"}"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("gtk-mac-integration")} -lgtkmacintegration-gtk3"
    end
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
