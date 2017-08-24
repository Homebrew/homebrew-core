class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.25.tar.gz"
  sha256 "c6abbbeb8cd44dc973d45d30bc5a7e42e212f2feba45c8e0489fab3c3cbf0d78"
  head "https://github.com/ott-lang/ott.git"

  depends_on "ocaml" => :build

  def install
    system "make", "world"
    bin.install "bin/ott"
    pkgshare.install "examples"

    site_lisp = pkgshare/"emacs/site-lisp/ott"
    if build.stable?
      site_lisp.install "emacs/ottmode.el"
    else
      site_lisp.install "emacs/ott-mode.el"
    end
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
