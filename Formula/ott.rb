class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.27.tar.gz"
  sha256 "e0ebb3742a6632312cf4de71dad4e4eadfe420b6b86a5d6df6776c4135044ac5"
  head "https://github.com/ott-lang/ott.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e0fee5c01837dce4ce480af3750bf0b177cd57a2babcaf6a13bf4ff4c5cd130" => :high_sierra
    sha256 "383420ca2a3c29a95eb3a7c22cada562dff900e5952a3bf2cfd552887a7ed269" => :sierra
    sha256 "ca2b4bb615be0404e3d74008fedb654e5081cf779fab89cd17660b4255982fcb" => :el_capitan
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
