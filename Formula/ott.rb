class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.27.tar.gz"
  sha256 "e0ebb3742a6632312cf4de71dad4e4eadfe420b6b86a5d6df6776c4135044ac5"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fb0b277c00fc9de9fe639b9718d9bf252550c275206e22c85f7242f29296914" => :high_sierra
    sha256 "cee50c7683cff89e76c10cd959e19c71b6542d110c2c3a1c1e79dfdd62b06f72" => :sierra
    sha256 "7d91858f513335a2df3db69127741dfebe47bed71ed27cde02dfd3d6c86bb309" => :el_capitan
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
