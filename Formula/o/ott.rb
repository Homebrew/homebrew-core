class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/refs/tags/0.34.tar.gz"
  sha256 "c14899fb9f9627f96fcde784829b53c014f4cd2e7633a697ac485ecb9ab8abd6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ott-lang/ott.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d4039e2b9e9c87406c25c32589f9d6b2f6967849565e8710122d157778136cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00cab8b9372dce0a39186602627d0755ebc64e9e2173c0b6a03859deebca7d77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3817587945b256d5acecaf8f35a070f686fe1549068669d783b4f362dbae37cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8e41fe66482af077ffffb1d5050d708915cf5eda57dfc4543f625258d3b23f5"
    sha256 cellar: :any,                 arm64_linux:   "7ee632f8b727db0d3762688c64ff21aa3b31aa8e1c728fb9c862a249c9521073"
    sha256 cellar: :any,                 x86_64_linux:  "0ff8bad1b988fb83648ff827508c286a016572cf1feeaca40fcf3d7f35330161"
  end

  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    # Only build the `ott` binary; skip `coq-ott.opam` which pulls in coq/rocq
    system "opam", "install", "./ott.opam", "--deps-only", "--yes", "--no-depexts"
    system "opam", "exec", "--", "make", "world"

    bin.install "bin/ott"
    pkgshare.install "examples"
    elisp.install "emacs/ott-mode.el"
  end

  test do
    system bin/"ott", "-i", pkgshare/"examples/peterson_caml.ott",
      "-o", "peterson_caml.tex", "-o", "peterson_caml.v"
  end
end
