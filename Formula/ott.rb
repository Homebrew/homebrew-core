class Ott < Formula
  desc "Tool for writing definitions of programming languages and calculi"
  homepage "https://www.cl.cam.ac.uk/~pes20/ott/"
  url "https://github.com/ott-lang/ott/archive/0.31.tar.gz"
  sha256 "3203f1b3eeb30e6aead9f63f6df22f5ead2407964ac9bb3cd5b0ae78df4568f8"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ott-lang/ott.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c3c0919b9f0c3225976e7126c1b909ba4ef3a9d0aade6461ec2c73e971adc73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40c61230f66924d6dc12f0e7c1eefd6baa29a40a9d0b560611ae47935d828c9b"
    sha256 cellar: :any_skip_relocation, monterey:       "159b3ac297aa40a4462d05e17534e0cadb97de1b2b6e68e1fe403209e8fe2884"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b1f04443bb7645a23898cb98a1308ebbf3033b2d9054e027ed59b722d6850b"
    sha256 cellar: :any_skip_relocation, catalina:       "22f441ac37e494c9b667838b43e87f820dcf2fe090c4794db7eb0cc3cbd514a6"
    sha256 cellar: :any_skip_relocation, mojave:         "7f4274253521ef41f38b674247906a6f9567dce515c80a5150111a1da0dc5caf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a59bb92116efa3e1b7c13da59a95dd7ad7a2618c6efc4b09d74a59001478bde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdc6d3369e71db55a8e32ce1e984b76bf91a11b0671201a2551ea2ce3e60ccd1"
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
