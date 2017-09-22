class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.26.tar.gz"
  sha256 "fda1380c33a661290b13241c56dd29c4e09667db738dcd68bc9b388e93137e2c"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed2772edcfd26b38e16d3fe7affef7f56e59d2104960119589147538b00feec1" => :sierra
    sha256 "346a4a25c142cac3b2c4c4c0ac05101999d034320344e74d37e6859307b1a0ec" => :el_capitan
    sha256 "6fdfc33c357a3ee8a6d89a4546c59ab916b41b2fc81cac4fcb177521f418c7b9" => :yosemite
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
