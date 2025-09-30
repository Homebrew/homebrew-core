class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/10.0.0.tar.gz"
  sha256 "66ff3c231abe2feaeb377f52bb188eb81686c162d7f3fd28ed5b7374f0046c48"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9e864b494ab69223c4cc4c2c13a6fd0c18ee3901a57ee9849049246f8e4f7ea9"
    sha256 cellar: :any,                 arm64_sequoia: "5a04f342abe94f8043873f428335a0c6a84250fb7286858c8e1a5fd8fb39c2e6"
    sha256 cellar: :any,                 arm64_sonoma:  "cdc99a59f5fccc3c03a9d5c0c929a2488a3ff24244b1cba6e7d62ac3c9da204f"
    sha256 cellar: :any,                 arm64_ventura: "45bbeb2050f67f8cc1934ab21318b957d65fde3855f0936c4c7a3a35c75aed5c"
    sha256 cellar: :any,                 sonoma:        "6870706cdfd71b70bad879a332f4f23bd30cec361447cf71a2da7a4c230e97f5"
    sha256 cellar: :any,                 ventura:       "fbd0d1f670f060de6b6ccd83c49d594fc0b65b7a9ba1d28e37065a1b9e7ded10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe11fc2b2f976a53a49a791eabf16b1cfa43ca223d5b7073fc9608fc7ef5bd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "193dceccee09d909d8be8dd0c328a6af8a522c282ebd53d21aad91cb936b74aa"
  end

  depends_on "rust" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libheif"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "pkgconf"
  depends_on "webp-pixbuf-loader"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  def install
    system "cargo", "install", "--features", "heif,libraw,libavif", *std_cargo_args(path: "czkawka_cli")
    system "cargo", "install", "--features", "heif,libraw,libavif", *std_cargo_args(path: "czkawka_gui")
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
  end

  def caveats
    <<~EOS
      czkawka_gui requires $XDG_DATA_DIRS to contain "#{HOMEBREW_PREFIX}/share".
    EOS
  end

  test do
    system bin/"czkawka_cli", "dup", "--directories", testpath, "--file-to-save", "results.txt"
    assert_match "Not found any duplicates", File.read("results.txt")

    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version")
  end
end
