class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20180401.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/bcpp-20180401.tgz"
  sha256 "3fee78476833a8d6c647f0b9f6ad85209cdb104a538349bc24538c7f7aede81f"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc81540bae3c797979fdd5246a97479b685683ed4ec611f5e9a1f691147356af" => :catalina
    sha256 "e27cfc6f4e0417a5ad0531f9b2dbf2630bc79d06404573c2a9a799717aa5dd4f" => :mojave
    sha256 "25399ade6485e4272d264611a32db839905b56a3607f04ad9d66a5571469aa03" => :high_sierra
    sha256 "339190468a41d319c161ab16933012517f68d11e5162d57b117bdc0220a51db0" => :sierra
    sha256 "62ea91b7f94761da062c0f78757f48299bdd614ffba1cbc9e3e44794b305901e" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
