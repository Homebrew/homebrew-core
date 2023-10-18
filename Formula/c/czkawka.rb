class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/6.1.0.tar.gz"
  sha256 "63e64c717a93b3d5210d6a4718833fdbf3ad7b28c9b74a243d9de3ab1ee6ad5a"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbe8e037bde658f9ca5a7759bfe3b95080cda6ec6dc9aa45174d7c5078706714"
    sha256 cellar: :any,                 arm64_ventura:  "e2b71c7b66839a1bada0efc1112f206f6540f08f6f2a34df0c34fde2bc5b9e58"
    sha256 cellar: :any,                 arm64_monterey: "f0cc5d19ede515e22a0e0e0795f72cdc114cdec53b07f8540205f8b0b807e337"
    sha256 cellar: :any,                 sonoma:         "3565bdc22a5826812f334e3ec2fc8e86cc38e6e0b1834e658e17d12cdef4cdf4"
    sha256 cellar: :any,                 ventura:        "e059266e48240234b079c17e2bb2c1dd97f39abe9c3856eb1ab742e174c0d17c"
    sha256 cellar: :any,                 monterey:       "ce5f5f266488f1aef777428e717594ebd8404a61a962ed8077dbdded68152281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902d6635984d301d8c34d7eb3eef5ad4b99b5f546e3749c2081f0ca7ca3c487a"
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
    output = shell_output("#{bin}/czkawka_cli dup --directories #{testpath}")
    assert_match "Not found any duplicates", output

    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version")
  end
end
