class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.36-r2.tar.gz"
  version "6.36-r2"
  sha256 "aaf1b2b81ef07b2cff1f0936cec3d7b6fda9a163170468e81d2ba2458faa353d"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1b0cccdcc6fd3e5e8bfc7d1fd4b2e69ab9750ca6d6cdef7c7659d97792be035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67a681c6a2c9f3020b7d5448879d5813c2f41d58438aa66afe6d43fde20428f9"
    sha256 cellar: :any_skip_relocation, monterey:       "0c154947a1820a62001c550c89ea803ae7622634a5a2862a87132b3fd64daaac"
    sha256 cellar: :any_skip_relocation, big_sur:        "5343b0bccbc4f87c0d025fd707e53cdb0469e37d3aea5f504f71618df8722426"
    sha256 cellar: :any_skip_relocation, catalina:       "415d3e2f87bb24f707837a73cd5d738cd9f24cbeb044381681f875328e5fe96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9db2f2f5ca89b16da784083beba1138baacf7376975011c19ed8914880ef27"
  end

  resource "homebrew-test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("homebrew-test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
