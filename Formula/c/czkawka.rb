class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/10.0.0.tar.gz"
  sha256 "66ff3c231abe2feaeb377f52bb188eb81686c162d7f3fd28ed5b7374f0046c48"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f4a6f85a1a1e7a47760212d0e14a68f9d4340708307e923407fdd4d512f9dc83"
    sha256 cellar: :any,                 arm64_sequoia: "c8e96fda2372e42d926f6d2d109b3e47f6f7ec7e93f58c12532b73a90b0a044a"
    sha256 cellar: :any,                 arm64_sonoma:  "9ec6361560f8ee4bc3f27f7335535cce2aa6974bdd6a164b637bf4e3e7896431"
    sha256 cellar: :any,                 sonoma:        "0f8379c98f1b1245f3108adfc23af72fe785f3c8f5f7218d963f990f402df140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e1164a69e5010b3e7141f43a653e128ac7021b3df1224e6cbc19a9935bd00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5524fde6900917e902e8144e4b60537507c5c0e4fc8f099d4683d9819face7fd"
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
    %w[czkawka_cli czkawka_gui krokiet].each do |cmd|
      system "cargo", "install", "--features", "heif,libraw,libavif", *std_cargo_args(path: cmd)
    end
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
