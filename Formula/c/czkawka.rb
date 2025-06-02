class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/9.0.0.tar.gz"
  sha256 "2b2f419e1c733cad763eceb95eff28b1302e0926c247fdfd98e2f29f6f7866ee"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c28c1d127ad049a7ea6ca83b912d198125fd1ff907a6f695512a23698692c235"
    sha256 cellar: :any,                 arm64_sonoma:  "af4ae38ba517763f591b5f2ab52b0b3fead5627d2ee80bda8db3db596e2760c4"
    sha256 cellar: :any,                 arm64_ventura: "0e0b5690c9450849adf554fdd0bfb7604160ee8030a3522f038c48d286d86afa"
    sha256 cellar: :any,                 sonoma:        "b962385e937d55de3c73bde9ff005a445060683d1eb1fe935cf4796d729c9baa"
    sha256 cellar: :any,                 ventura:       "4845dcbc5835c39c85987bebc64eaa14f449b6a36a8d669e8f0799bab7c22cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "639ef911d5321e575feeb023000967a18e8cd968cdb7e03952e3ddf4bf90d15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df85cb1e5414b32e3026bd639dab932af37063363e1eb9cf58a8b46d0408f8e7"
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
  depends_on "pkgconf"
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
