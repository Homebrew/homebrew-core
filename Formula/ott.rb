class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.30.tar.gz"
  sha256 "ffd757e17d618a3162f0822e09b86d3879071e35378f47c9f6cdc16b757274ca"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61309aafe923d5ff35914516b48adb21ab3d2aa95a317b8d827cde1166e2252e" => :catalina
    sha256 "28c5c4755f6e7c34e6ef86009fa839b694ac00136fb822132e38fa06a5361be3" => :mojave
    sha256 "ed14bf477139c689eaa93ec2d0fb3c6cc73940a04d194621819f417d18bae033" => :high_sierra
  end

  depends_on "ocaml" => :build

  def install
    system "make", "world"
    bin.install "bin/ott"
    pkgshare.install "examples"
    (pkgshare/"emacs/site-lisp/ott").install "emacs/ott-mode.el"
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
