class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/12.0.2.tar.gz"
  sha256 "b9e1722ac2625aa0c5861eac6499cafe9e4e7cc0bc9a429c8c3ad6c1e8cd68f1"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "11a32f82785ff96537f5bb64a72be6b1829f585e137e786375bd8d483e96e4f8"
    sha256 cellar: :any, arm64_tahoe:       "513666a7487a0ab16a9818e1daa75cc045279ad7d742b4de45380e6871a84f9c"
    sha256 cellar: :any, arm64_sequoia:     "3f92eaea49acc4c8e885f7ff3ff363761337d09a82e4f95725d0aa9eb8694229"
    sha256 cellar: :any, arm64_sonoma:      "300e57b54a53c1f781b83df2cf3a5ecdde4005e834e53e0ed8bcf6965f9b38b7"
    sha256 cellar: :any, arm64_linux:       "ba3de80035aeeb5ce460bce3c5385facdcca2e7ca41671db4335219a49de561e"
    sha256 cellar: :any, x86_64_linux:      "bf79065804f142f0270c8c03ce8214ae295b0fb52d31e8f910a9688f00f8f70a"
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

  post_install_steps do
    compile_gsettings_schemas
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
