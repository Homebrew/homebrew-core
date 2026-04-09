class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/11.0.1.tar.gz"
  sha256 "8a6e3f634bfd2b6ed9b7f8634e7405ebb6d756f20bcdd99d15028ffb6b030eca"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b1137ad14a3250af05268e885371bb199becdfe7d32284446071073771e755e"
    sha256 cellar: :any,                 arm64_sequoia: "be7130f184c8c7971eb969f8e498c18f773a6ad108bfaeb5e30b20940c752be6"
    sha256 cellar: :any,                 arm64_sonoma:  "e480ebc78cc41f7661215626ebb0d17e6246aa2f228f70176800b1d6bca5a68f"
    sha256 cellar: :any,                 sonoma:        "2ecd2be335f5e988461b7808eae9d0834ab5b6c0c8a397fbac9c3f7b8a8c306f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d0d648452d82c9faf8b2a72871dfa0d5ceb94118cc029f76ce3e548503390c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f642d209d45b9316ca74edeb7f8da1b31ebfd0867471fa0d78381590fa604590"
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
    features = %w[heif libraw libavif]
    %w[czkawka_cli czkawka_gui krokiet].each do |cmd|
      system "cargo", "install", *std_cargo_args(path: cmd, features:)
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
