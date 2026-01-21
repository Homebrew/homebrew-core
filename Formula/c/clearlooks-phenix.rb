class ClearlooksPhenix < Formula
  desc "GTK+3 port of the Clearlooks Theme"
  homepage "https://github.com/jpfleury/clearlooks-phenix"
  url "https://github.com/jpfleury/clearlooks-phenix/archive/refs/tags/7.1.tar.gz"
  sha256 "8219c025341b2eaa992cba01e7ff6da3397e5a005fc4ae1038fdb371efcfb0ce"
  license "GPL-3.0-or-later"
  head "https://github.com/jpfleury/clearlooks-phenix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37f83957b60d7f567870434c313d3d02340d40ff4cc32a7deb81134fe2570b96"
  end

  depends_on "gtk+3"

  def install
    (share/"themes/Clearlooks-Phenix").install %w[gtk-2.0 gtk-3.0 index.theme]
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f",
           HOMEBREW_PREFIX/"share/themes/Clearlooks-Phenix"
  end

  test do
    assert_path_exists testpath/"#{share}/themes/Clearlooks-Phenix/index.theme"
  end
end
