class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.14.tar.bz2"
  sha256 "87187e49d301c510e6964098cdb612126bf030d2a875fd799eadcad3eae56dab"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/klavaro[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "1953be5367f25a7ff30e60797c10c98d1c7a5cf28911c512e4904faf5f9f9519"
    sha256 arm64_sequoia:  "f51c0783c7004a02723e01896663c837923fe3ef5efc576821e68deb3383387c"
    sha256 arm64_sonoma:   "da78d9074c10ef13c0c188880d8c66d72aa130734a240d696a5ff67676f1557c"
    sha256 arm64_ventura:  "df780d1ae34c336fc12c7facbb053a3466cfa0a458d11744fd9cf8b650420cf5"
    sha256 arm64_monterey: "7ed497aacf317e009ccaf17e06e2652d7b1a51e2dd4621edeebead557513197e"
    sha256 sonoma:         "9a3e25bfb9566643a127ceccd4b646b90cfbbe733f0416fcd0f8ad46f9e6759b"
    sha256 ventura:        "756f253d5890c66e7ed6554ed23b6f16fb18f305afe73cbfd3e33f964e8b4d8b"
    sha256 monterey:       "609d595507d40c138aa3d3e565d6e92826f4b8ab570b5dbc389b917b3991b297"
    sha256 arm64_linux:    "a42fad29e4aba488b46ffc11945cef3d1210d85efb853a3469b3b27e40f68a0f"
    sha256 x86_64_linux:   "847abc58af56c8af7a36c95f7ea4a239906b0078b2fe39393750397c8c03db53"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtkdatabox"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
