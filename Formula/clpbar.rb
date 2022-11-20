class Clpbar < Formula
  desc "Command-line progress bar"
  homepage "https://clpbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/clpbar/clpbar/bar-1.11.1/bar_1.11.1.tar.gz"
  sha256 "fa0f5ec5c8400316c2f4debdc6cdcb80e186e668c2e4471df4fec7bfcd626503"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d3ff5e627cdb58179f1ea37f38cfa62e3ffc2751984d4d0c53c787f34f40f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56041768cea07ca805047e0d319a5ed863e6b2d61cbfa626c3744c2ba53e08f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e3c00a0a305c5ce2cc71cfb00fea55f9993976d1f63a73e7ea64022d47550be"
    sha256 cellar: :any_skip_relocation, ventura:        "536fa2e325dad3dfa4bb63876bc54c9ebea202dadd68d8a87c517842906df821"
    sha256 cellar: :any_skip_relocation, monterey:       "90f14242e4340c8c8a9ec84271d5e629c03314df3761fc6033430cd3d9ae33ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba23543dd87e39ec0baea12951bcc835b65b67b8ef56b024a39d282781f3b62"
    sha256 cellar: :any_skip_relocation, catalina:       "86aefc9d1110a945b62a9dbd9d1efe2a1c4ebaade84ad56d00084857439914a8"
    sha256 cellar: :any_skip_relocation, mojave:         "6d00ea5044914b14d7e7c901eac63641085496b6fd474c9491e46109c6599709"
    sha256 cellar: :any_skip_relocation, high_sierra:    "eb3648e3cc14ab0712c6a71d3df6eab53bd66bad86a402df1716df3db09c0358"
    sha256 cellar: :any_skip_relocation, sierra:         "769dbb64e877ab1f52a496063bbfdac32911f38e6e25b4fc70a5cfe937923f5f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b54fa0ce24de6dda141e3fc025b67f2e0216b01a3664ec5992a98f8087881ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34f612cc13329af2cb8bb90f7457a5222538acbd7304ad2ebf0a16650bec2dfc"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix='clp'"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/clpbar 2>&1", shell_output("dd if=/dev/zero bs=1024 count=5"))
    assert_match "Copied: 5120B (5.0KB)", output
  end
end
