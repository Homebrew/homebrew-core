class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/7.0.0.tar.gz"
  sha256 "ce7d072056dedc4f2ca4d3647dc786ba071d4f3c58e79415da18d7dafd62e87b"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d17367de2f7b896a58efae5ca41830614a2e4fd689e8668c305133c937ea2c76"
    sha256 cellar: :any,                 arm64_ventura:  "fa017774f8c98c96c11cbb8bb76b2bedd7abd591d2636ede733ab62c371cb784"
    sha256 cellar: :any,                 arm64_monterey: "b5553b503b7500cfe3c582426760d63b132cd9f4cd8ee24b4d2b41844afe2f4e"
    sha256 cellar: :any,                 sonoma:         "baa04c19350433d017831d7457d5a35c75c7fbc5290b4112bb994787bc7f06d9"
    sha256 cellar: :any,                 ventura:        "b7bcab24f61e453034cc803bb2743d0fce7c2e2345e2749063514a163cb3ff44"
    sha256 cellar: :any,                 monterey:       "ece5ccc15c1f8f9a47986026bbb20f259d164d968d2d4684c63237ad3a33532e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3194269936ed396ae49ec4dbccf8ac6525af961a2fb98910c6d1efa916216f84"
  end

  depends_on "rust" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libheif"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "pkg-config"
  depends_on "webp-pixbuf-loader"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "czkawka_cli")
    system "cargo", "install", *std_cargo_args(path: "czkawka_gui")
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
    output = shell_output("#{bin}/czkawka_cli dup --directories #{testpath}")
    assert_match "Not found any duplicates", output

    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version")
  end
end
