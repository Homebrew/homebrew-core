class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.4.tar.gz"
  sha256 "2300082455bf6a10d71a020d8b837d986dd72b0ef82572baf922f118c67cb52d"
  license "ISC"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05b1fb03e03f8f4dce4484d9ef866159c0b46ebacfaf93c25d542eee54281703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25ee1164b3312255ecfc046555f575f1ebf20371f7fe189c686142896d520115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b0710f623c89f3840148e02891c94b468893cb8b174da5c5b0774bd7cd3209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6eb787bc5394b64ccfe181e402594d0d2b5576d296eed60383027014e41bf3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6b7fcbabd02a03bab68f74d523936a34a7461e69e499022985316b6bb16cbbe"
    sha256 cellar: :any_skip_relocation, ventura:       "8399f66362e20f4a34d3e69163eef9ef4d11d08bf21f48151f281beee1eaf816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b88cad663f4d20303d0b4e0f5f4fb62a78a7cbfaab950925eb1536f33564519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c7d1aabdd8c6703627c23d63e5ef52e611046fab89e8a81030623b58f82095"
  end

  depends_on "libpq"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
