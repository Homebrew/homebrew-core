class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r3.tar.gz"
  version "6.35-r3"
  sha256 "6284a60b7680cc5e228ad6d944d88d6f3eeee5838812ee86dbe42910c9f6e7e2"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "405eb7f9b7210aac100f069acc228a8058013c947961bc3c9ab1a0ede7a24740"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d546e5f3ad90dec09e480b1be8f6cac0d1cd3a62138444f17b827eb599c169d"
    sha256 cellar: :any_skip_relocation, catalina:      "dd0c1f7bbc4c07025ceca29441fa6dc8b821c6dfc0224a7576d64f714db34a53"
    sha256 cellar: :any_skip_relocation, mojave:        "2cdc7aa7871f147452be33738b78ed671e8006def20cd2774cdea610bda04878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3712d8dcc5f3ec6edd340e2d88a5d81949463d08c6bfd5883cccc8f02ad585c"
  end

  resource "Adventureland.inf" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails at:
    # install -d -m 755 /usr/local/Cellar/inform6/6.35-r3/share/inform/punyinform/documentation
    # install: /usr/local/Cellar/inform6/6.35-r3/bin/punyinform.sh: Not a directory
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
