class ClearlooksPhenix < Formula
  desc "GTK+3 port of the Clearlooks Theme"
  homepage "https://github.com/jpfleury/clearlooks-phenix"
  url "https://github.com/jpfleury/clearlooks-phenix/archive/7.0.tar.gz"
  sha256 "7f46b24e679a5c8bd63c356f905fa755e473cf606658e926c487416d899f99a8"
  head "https://github.com/jpfleury/clearlooks-phenix.git"

  bottle :unneeded

  depends_on "gtk+3"

  def install
    (share/"themes/Clearlooks-Phenix").install %w[gtk-2.0 gtk-3.0 index.theme]
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f",
           HOMEBREW_PREFIX/"share/themes/Clearlooks-Phenix"
  end

  test do
    assert File.exist?("#{share}/themes/Clearlooks-Phenix/index.theme")
  end
end
