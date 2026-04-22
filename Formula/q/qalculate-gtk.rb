class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.10.0/qalculate-gtk-5.10.0.tar.gz"
  sha256 "310875ae42d4af3bef46bb5f0405496c26e8e8abe218caeb1270cde176c02691"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "958727ab7c13a897ede3acf494a62ec24fcdea14c8701f8412a11b3eae7c9706"
    sha256 arm64_sequoia: "4020a8c0863a66b6672070e7d75383ad26d55be1b5670e9a121ce6b8f3779915"
    sha256 arm64_sonoma:  "928fb2158b741ed69717b345d0ba556c61fa77ceae2e0c4fb1719f86f1767298"
    sha256 sonoma:        "4a9ecb61d73152b9f50db61867c0aeca7365c1a85757325829578f7558e26def"
    sha256 arm64_linux:   "e1d2f26a06f738d15ec465abbe519eb191a300295bb215351d6368cb4733cfa8"
    sha256 x86_64_linux:  "424e2335a8b2caff244937fef8feb536419cd6bf3df98811de76f76e5c0aa72b"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "gtk-mac-integration"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.mac?
      ENV.append_to_cflags "-I#{Formula["gtk-mac-integration"].opt_include/"gtkmacintegration"}"
      ENV.append "LDFLAGS", "-L#{Formula["gtk-mac-integration"].opt_lib} -lgtkmacintegration-gtk3"
    end
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
