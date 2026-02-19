class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/11.0.0.tar.gz"
  sha256 "d73793dd713a80b3dc052de1b69de4c94d1fef8b8ff3efb4ce8a285622354a26"
  license all_of: ["MIT", "CC-BY-4.0"]
  head "https://github.com/qarmin/czkawka.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "043e7c4d1aa61abf1956a938e195d37289b4b209563a0424d1ac822b8dfbdab5"
    sha256 cellar: :any,                 arm64_sequoia: "5dd80f9e7111e10531c2d62951115541d6808520f84cf588110cd7da2e3697b2"
    sha256 cellar: :any,                 arm64_sonoma:  "0771f3bc0fe685c0762137b8ebde31d503d2f3dc78cca7cdd69a1c5369e8c2be"
    sha256 cellar: :any,                 sonoma:        "b6685cd288367d3eb70b476d45131036d698300c5cf6e03eac8a558a07b04ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e440c2e5f3434878cefb09df00950197eba4c1062e188808b08a0908d80eaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67efd9c952324aef3a112a73e6ea86a2fba3c1ac51b5a445c64c7e14dd1dda95"
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
