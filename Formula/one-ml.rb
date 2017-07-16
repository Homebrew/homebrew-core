class OneMl < Formula
  desc "Reboot of ML, unifying its core and (now first-class) module layers"
  homepage "https://www.mpi-sws.org/~rossberg/1ml/"
  url "https://www.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "97fd29ed2044756e418c6ae09c70796b112c5677d716c5032e7b77f002c3a658" => :sierra
    sha256 "1d3496b1f0cc6d06d1a9b68a53c0d5d182cbc791a3795c61605e1b406d2eb394" => :el_capitan
    sha256 "c1052202350991040d99b3316a18cc808d8e16f75bb475edad18a73cc71da902" => :yosemite
  end

  depends_on "ocaml" => :build

  def install
    system "make"
    bin.install "1ml"
    (pkgshare/"stdlib").install Dir.glob("*.1ml")
    doc.install "README.txt"
  end

  test do
    system "#{bin}/1ml", "#{pkgshare}/stdlib/prelude.1ml", "#{pkgshare}/stdlib/paper.1ml"
  end
end
