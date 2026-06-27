class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/11.0.1.tar.gz"
  sha256 "8a6e3f634bfd2b6ed9b7f8634e7405ebb6d756f20bcdd99d15028ffb6b030eca"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "94cd50c796446b7b54dbdb497b7d3ab136522203a3239ee6af13ca3611407970"
    sha256 cellar: :any, arm64_sequoia: "d57e96dc78a6eff71ca82bd29efabb81eb15367a63dd1d0581ba570a84ddd0dd"
    sha256 cellar: :any, arm64_sonoma:  "a2d0d569a27eb29107f0a89450a49429b4361aa42f82e0e693e7ba5e06d531f2"
    sha256 cellar: :any, sonoma:        "31044c083fdf428e49206b4345275f0094b23ada1fbe2cf1db495d7f43cd7d6a"
    sha256 cellar: :any, arm64_linux:   "12c7c0336a8a2c11968857331e39e6ffc1b14adf0ff9ec68eb3b5d56149054e0"
    sha256 cellar: :any, x86_64_linux:  "81f42c65b7d9ce15214821c1a3ef0494c26302011cc5355d3f80a96f47137f11"
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
