class Bashish < Formula
  desc "Theme environment for text terminals"
  homepage "https://bashish.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz"
  sha256 "3de48bc1aa69ec73dafc7436070e688015d794f22f6e74d5c78a0b09c938204b"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "593a8963d32a22c3c7a65c3d1f9f8ae8fec9a0a85dffe8ad5c71baba839091ca"
  end

  depends_on "dialog"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"bashish", "list"
  end
end
