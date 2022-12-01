class Akku < Formula
  desc "Package manager for Scheme"
  homepage "https://akkuscm.org/"

  url "https://gitlab.com/akkuscm/akku/uploads/819fd1f988c6af5e7df0dfa70aa3d3fe/akku-1.1.0.tar.gz"
  sha256 "12decdc8a2caba0f67dfcd57b65e4643037757e86da576408d41a5c487552c08"
  license "GPL-3.0-or-later"
  depends_on "guile"

  def install
    system "./configure",
           "PKG_CONFIG_PATH=$HOMEBREW_OPT/guile/lib/pkgconfig",
           *std_configure_args,
           "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_predicate "$HOMEBREW_PREFIX/bin/akku", :exist?
  end
end
