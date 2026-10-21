class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.40.2/mk-configure-0.40.2.tar.gz"
  sha256 "bcef9d12f5e7e2ef3623d97981d2b77a1a70d6982bdb266c3ce5deef7fd863fa"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7f60b573eb1b8f32294c06dc64e45763d048382baa1ac18afe10b9445a353f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed1f8c9202cfb6db52541a0f10df245d509fc65272d0ef8e71efbd0484e97b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e75aa24b899577cb752dbcd6adba9c252415a1bac9250026992b2ee24487f9e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a6de8357a9d466c63fea644ed45d8ed13139efa6c977e02c2775c78b8b5f9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c97110b1533107cf566ba07a2e02af894366d1a3b3d5727888f37c15f7fe4846"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system bin/"mkcmake", "-V", "MAKE_VERSION", "-f", File::NULL
  end
end
