class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/refs/tags/0.33.tar.gz"
  sha256 "d64ec4527f8ace56a407fc67957840d1653980fb0112d7fa8f2b0fc958501f7b"
  license "BSD-3-Clause"
  head "https://github.com/ott-lang/ott.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c138f305f0c33843f5c9b69298f1ab095680bd72aef50f091635d74d3d8ce5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c6201ade0bebc2bb75696d6e53e5fb589692aa716f3fd09178d5050e4bc00e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfff4519a3ba70b177252aa268bee375fd93d59a4d0dc6adbe1b26169400f555"
    sha256 cellar: :any_skip_relocation, sonoma:         "c86c2362dee1ccfcec917430e9fb32de810ba4dad3e13bdecdd6ca2d73bdcd3a"
    sha256 cellar: :any_skip_relocation, ventura:        "ff36d9f8050eafd7a789c078669418bf480f216e06b6d5a0dec9b399d14e563c"
    sha256 cellar: :any_skip_relocation, monterey:       "d45a7148e22a09d5ee1bf4fe17a103aa5caf0b0acac1a12a88dc48c6c0a1d3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fac1121b49f993443edae09205bdaf9a63fe2252ee7d848def1f1ae88f22790"
  end

  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"
    system "opam", "exec", "--", "make", "world"

    bin.install "bin/ott"
    pkgshare.install "examples"
    (pkgshare/"emacs/site-lisp/ott").install "emacs/ott-mode.el"
  end

  test do
    system "#{bin}/ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
