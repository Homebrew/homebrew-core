class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/12.0.1.tar.gz"
  sha256 "0503f6969a2184fbe2b6b6d786a4ae1b50779f4ce62b57223d1407c70f500587"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2bba6875429744f6de089c7afc59916dfb4395de33b93113e687387468b9f99"
    sha256 cellar: :any, arm64_sequoia: "b15b3fbaf4f818312e04c998004a3165e4e1acc4314824821f1f8c88c869c36a"
    sha256 cellar: :any, arm64_sonoma:  "86191a915f94ae0c896081be6e2f98d4cd6163acf62f2eb78690975fd2bdf32b"
    sha256 cellar: :any, sonoma:        "6d9f580dbc3384fdce6bdd42654a740287f35b745826e5135e3f11d65c79dd71"
    sha256 cellar: :any, arm64_linux:   "bba6c7dbaf9f8a5e9474649fcf7655382eb6d7076cbdc1bde0407c6a7f4e8f65"
    sha256 cellar: :any, x86_64_linux:  "f9fa7ec6ad8e318964e3bf80c4b5e5b400f5758760e2110610da3544a69e5e35"
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
