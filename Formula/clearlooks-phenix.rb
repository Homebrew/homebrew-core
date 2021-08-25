class ClearlooksPhenix < Formula
  desc "GTK+3 port of the Clearlooks Theme"
  homepage "https://github.com/jpfleury/clearlooks-phenix"
  url "https://github.com/jpfleury/clearlooks-phenix/archive/7.0.1.tar.gz"
  sha256 "2a9b21400f9960422e31dc4dabb4f320a16b76776a9574f0986bb00e97d357f4"
  license "GPL-3.0"
  revision 1
  head "https://github.com/jpfleury/clearlooks-phenix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b785c8577696a7fdaa9d1c8f1130e7653972d7b1a497d0ae37ebbf1cb79cf30"
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
    assert_predicate testpath/"#{share}/themes/Clearlooks-Phenix/index.theme", :exist?
  end
end
