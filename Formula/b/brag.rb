class Brag < Formula
  desc "Download and assemble multipart binaries from newsgroups"
  homepage "https://brag.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/brag/brag/1.4.3/brag-1.4.3.tar.gz"
  sha256 "f2c8110c38805c31ad181f4737c26e766dc8ecfa2bce158197b985be892cece6"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1dc1883ed39f5e1c2335a0639cfb3f67b5b7245a7a4e579996eeaa75579d688e"
  end

  depends_on "uudeview"

  on_linux do
    depends_on "tcl-tk"
  end

  def install
    bin.install "brag"
    man1.install "brag.1"
  end

  test do
    system bin/"brag", "-s", "nntp.perl.org", "-L"
  end
end
