class Epstool < Formula
  desc "Edit preview images and fix bounding boxes in EPS files"
  homepage "http://www.ghostgum.com.au/software/epstool.htm"
  url "https://src.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/epstool-3.08.tar.gz"
  sha256 "f3f14b95146868ff3f93c8720d5539deef3b6531630a552165664c7ee3c2cfdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4c73d7a9d89779c9b7bba39531f0c7605caabb5dc17dc390f5a440719ec4e7f" => :catalina
    sha256 "99cd88b7e087c3f55b3a0fc49ef08901a9e79745191e5ce551f268148a011dd1" => :mojave
    sha256 "4e41615a63d60d963029768b0618d43e29142e5495fb693a7f5844d2cb6f0d6b" => :high_sierra
    sha256 "d53d1f3d353d0f68f52b87603a67ca97942fb714f766a54636c142550568cbd0" => :sierra
    sha256 "92efa66cd268f0447dc52c14e9da04ae8af01b1691ec8eec3df61bbeb947b713" => :el_capitan
    sha256 "bb2aefa17b699127f2f6ed65004c9acbf7e5e5122f6f4b920d1e03fb9bd87b2e" => :yosemite
    sha256 "ae3c4b14dd19d3ac43947eff025a0fa3eabbe832333922359f9f74e0fe5e1d3d" => :mavericks
  end

  depends_on "ghostscript"

  def install
    system "make", "install",
                   "EPSTOOL_ROOT=#{prefix}",
                   "EPSTOOL_MANDIR=#{man}",
                   "CC=#{ENV.cc}"
  end

  test do
    system bin/"epstool", "--add-tiff-preview", "--device", "tiffg3", test_fixtures("test.eps"), "test2.eps"
    assert_predicate testpath/"test2.eps", :exist?
  end
end
