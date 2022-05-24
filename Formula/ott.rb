class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.32.tar.gz"
  sha256 "c4a9d9a6b67f3d581383468468ea36d54a0097804e9fac43c8090946904d3a2c"
  license "BSD-3-Clause"
  head "https://github.com/ott-lang/ott.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511bf3f6279cba0c1714a9bcbc91b2b988b3407f5a9ffdcab04528bf1045a4a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dfaa3e076ad777bb50da8904c52eb7742fb9158747d7f83bec71542f871972d"
    sha256 cellar: :any_skip_relocation, monterey:       "09ae9f15978dce2f09f98d3ee1bd0ea77f53bf9872a9f2270a759abfc85b6a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d80abf32c8153b5c72db279404531851fd09a5efdc6232c1d67bbf865dd8f73f"
    sha256 cellar: :any_skip_relocation, catalina:       "f2045c4dbc0ef48247e47274dbf546624fa68d46bd022e0a4365153f3c5e0275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca84d7f68137c731edd143156701f3abca196a1aacfc36120ec31b545549a55"
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
