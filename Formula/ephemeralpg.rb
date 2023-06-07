class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.2.tar.gz"
  sha256 "c07df30687191dc632460d96997561d0adfc32b198f3b59b14081783f4a1b95d"
  license "ISC"
  revision 1

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317bb739f9ec9100420e8610b60de8545f9415f6e1842968bdee2c6aa3eb8bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbc1d493222d98063a3a26ea7c544ed95069a206405428fb8ed768a359f4e781"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da97cd5215b93c553ed8e83be7daf0e96e5fe18aa86cebd1811605f2a46914b8"
    sha256 cellar: :any_skip_relocation, ventura:        "263930f92f1db1a82a3572b37ceb871ba2744df7c3a5068e1bf39934218f5b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "bdcd29d9bb83d00a3c268601e136f8e74fdf3bf9c978e26da82e759c0e02a32e"
    sha256 cellar: :any_skip_relocation, big_sur:        "87f038160a7d518b665937d40ed387edc90e7b0f92641ec7d6346464a825df49"
    sha256 cellar: :any_skip_relocation, catalina:       "cf6b45e47f686ab47ca274a30dbd6fe787eea74f8162e7dc61322188a9a0c686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3454fbf8bece737cc086c64244bea28033481d4db4b0d55426096483f32537"
  end

  depends_on "libpq"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
