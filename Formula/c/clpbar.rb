class Clpbar < Formula
  desc "Command-line progress bar"
  homepage "https://clpbar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/clpbar/clpbar/bar-1.11.1/bar_1.11.1.tar.gz"
  sha256 "fa0f5ec5c8400316c2f4debdc6cdcb80e186e668c2e4471df4fec7bfcd626503"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "428cfe8bba0bbe5074e6ea1f27f05ead41dd9fd65007b4ae9a9490e1673911af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b0b9fe17e86d7a2f3af256a5a55343351fb8d8affe328a5293290ba83fc4d5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6475090688882a9c4e55d754641a2739da88bad7cc68b3b5825c0454e8bcf89a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d3ff5e627cdb58179f1ea37f38cfa62e3ffc2751984d4d0c53c787f34f40f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56041768cea07ca805047e0d319a5ed863e6b2d61cbfa626c3744c2ba53e08f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e3c00a0a305c5ce2cc71cfb00fea55f9993976d1f63a73e7ea64022d47550be"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4d8adb0e57f2e29c8ed5f2cf86793d5e3e1d96f2ee4df1dddeece67ac939b28"
    sha256 cellar: :any_skip_relocation, ventura:        "536fa2e325dad3dfa4bb63876bc54c9ebea202dadd68d8a87c517842906df821"
    sha256 cellar: :any_skip_relocation, monterey:       "90f14242e4340c8c8a9ec84271d5e629c03314df3761fc6033430cd3d9ae33ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba23543dd87e39ec0baea12951bcc835b65b67b8ef56b024a39d282781f3b62"
    sha256 cellar: :any_skip_relocation, catalina:       "86aefc9d1110a945b62a9dbd9d1efe2a1c4ebaade84ad56d00084857439914a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a8ddd40caccc3e89ff5a39180cf69afcbec356f9579d9c40c5798cddfbfd46c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34f612cc13329af2cb8bb90f7457a5222538acbd7304ad2ebf0a16650bec2dfc"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--program-prefix='clp'", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/clpbar 2>&1", shell_output("dd if=/dev/zero bs=1024 count=5"))
    assert_match "Copied: 5120B (5.0KB)", output
  end
end
