class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/12.0.0.tar.gz"
  sha256 "cc5183c2ad251bc83d67dc6b12205a0d3d41a568ef89f16db27eb81f15c20e02"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbd91aeaeea13d784aad024d1926755cb54e97ba3603c83557539e0b6b227033"
    sha256 cellar: :any, arm64_sequoia: "41edeba6ec6a708e278776bb42ace0107f295c45bfcd830a2dcb80239bf0c71d"
    sha256 cellar: :any, arm64_sonoma:  "0c20a7374fd6513086391621f8931334d4220c3f7ca462c3541e0ee77181d33d"
    sha256 cellar: :any, sonoma:        "a822a840fcdb01d913d535f7818000c434b47dcc3d58b649c7ce938af32961d2"
    sha256 cellar: :any, arm64_linux:   "aa50e74db6089a69aaa2887ddfadab779719b21bfd5e5438f1fc6e06f5f2bf8c"
    sha256 cellar: :any, x86_64_linux:  "dd7419ea7d61ed1f2a488dbf2dc7500f24e74e38bea7a21b3270a5d8370f932e"
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
