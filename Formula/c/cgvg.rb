class Cgvg < Formula
  desc "Command-line source browsing tool"
  homepage "https://uzix.org/cgvg.html"
  url "https://uzix.org/cgvg/cgvg-1.6.3.tar.gz"
  sha256 "d879f541abcc988841a8d86f0c0781ded6e70498a63c9befdd52baf4649a12f3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cgvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "06ba6e4b8f27a86f39d20fa7d6b0b456d584d9973f15c5a7916145ae46c4d989"
  end

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "Homebrew"
    assert_match "1 Homebrew", shell_output("#{bin}/cg Homebrew '#{testpath}/test'")
  end
end
