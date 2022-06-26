class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.2.tar.gz"
  sha256 "c07df30687191dc632460d96997561d0adfc32b198f3b59b14081783f4a1b95d"
  license "ISC"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acaa7a804e803acae03d56e99b99bd3ae78c84a712529ea080f9540faf6a87c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5316cb0c4b7350c06ad7cf702a9843a9ab6a9788bf651e89d0c3aa813592797"
    sha256 cellar: :any_skip_relocation, monterey:       "d6bfd00086fcd556a5165d27e0cc98da4c95c9deed16b9e49dcca44fa3f150e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "00880249d548160c503fe729a9e84976d96233fe84ea1ef8b96b29797104e987"
    sha256 cellar: :any_skip_relocation, catalina:       "4627d6da5a0cc60abe8791ddf82c65c8615f2e76a5e0709762f6005cae1ead59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "476f081d37f2ea07c6f196b27190943b51e2f8d68a0c5775fd943b0078de9a56"
  end

  depends_on "postgresql"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
