class Brag < Formula
  desc "Download and assemble multipart binaries from newsgroups"
  homepage "https://brag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/brag/brag/1.4.3/brag-1.4.3.tar.gz"
  sha256 "f2c8110c38805c31ad181f4737c26e766dc8ecfa2bce158197b985be892cece6"

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "uudeview"

  def install
    bin.install "brag"
    man1.install "brag.1"
  end

  test do
    system "#{bin}/brag", "-s", "nntp.perl.org", "-L"
  end
end
