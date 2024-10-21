class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/8.0.0.tar.gz"
  sha256 "df67ca80b1307e8497afee057e139498ff5d80edc65e6c1f14b467bdf212033d"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4251216db038715034c03c6c7771256c5d09c4d02fe3bbb89a1c676c319628b9"
    sha256 cellar: :any,                 arm64_sonoma:  "7d0ccb7fdcf7ddc1dc4ebfe4a831009063b1405868f58b885b573d636b326ef1"
    sha256 cellar: :any,                 arm64_ventura: "3bb60036c0938c900b5e5f1b3e05515645ffeacf1c5dbe2d73526ffbe4522604"
    sha256 cellar: :any,                 sonoma:        "f435560c9131d7857c778d5825445ad1c57cda37d914015ee1cb20f01a1cf00e"
    sha256 cellar: :any,                 ventura:       "8c92f1b6344fea9416061d451a9017fdf7bd0e9fb5c3d384a5ae4742f23e7cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a014f1f3b9dd05b8a3b91738400b106e78458301a2315ab140e3be34357aa172"
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
