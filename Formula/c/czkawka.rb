class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/6.0.0.tar.gz"
  sha256 "32dc1d8a55bc3ce478246830a1f81679affa85735e69aa049fd83e30271e368f"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2125f4140031578713e01c1bac342abb820335b055c26e715a3fef419102f688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be17333e389d968109758ae3dc14ad48abda93c97c0f23f79c24ea9e8a3d465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76739fe606b5e23b6b56e627784e739624731b793d4f1f5a704a8e79fcbdd5ba"
    sha256 cellar: :any_skip_relocation, ventura:        "00af83011687eeabdc799939d1356719fb915087e771e43928004c0a3675cb87"
    sha256 cellar: :any_skip_relocation, monterey:       "49b00193f4bdf29ab78856f35de3da1d91b3629fd0f391cde46b3e845fcff6eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "64029ce9a7db71b6d24fc1fd735f873a4efde30c9a7ee0e342536956d76efa8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4db972d5d82cf88d5d1792942119f3c64392a04363e7badcc5938ae5568faec7"
  end

  depends_on "rust" => :build
  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg"
  depends_on "gtk4"
  depends_on "libheif"
  depends_on "librsvg"
  depends_on "pkg-config"
  depends_on "webp-pixbuf-loader"

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
    assert_match "Found 0 duplicated files in 0 groups",
    shell_output("#{bin}/czkawka_cli dup --directories #{testpath}")
  end
end
