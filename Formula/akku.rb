class Akku < Formula
  desc "Package manager for Scheme"
  homepage "https://akkuscm.org/"
  url "https://gitlab.com/akkuscm/akku/uploads/819fd1f988c6af5e7df0dfa70aa3d3fe/akku-1.1.0.tar.gz"
  sha256 "12decdc8a2caba0f67dfcd57b65e4643037757e86da576408d41a5c487552c08"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/akkuscm/akku.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "guile"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"akku", "init", "brewtest"
    assert_predicate testpath/"brewtest/brewtest.sls", :exist?
    assert_match "akku-package (\"brewtest\"",
      (testpath/"brewtest/Akku.manifest").read

    assert_match "Akku.scm #{version}", shell_output("#{bin}/akku --help 2>&1")
  end
end
