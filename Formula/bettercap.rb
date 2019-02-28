class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.17.tar.gz"
  sha256 "a4303eca6e7ed2aabe23638a2f2eb61b0786911e6ddb5153500b3d1ffe7af252"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbebd63ad2480bead55a585653d25a9689a8dbd60c057265e13f5a00936c9b49" => :mojave
    sha256 "11620c3ed5fbaa20c51cba7441b01be64ae1ff89e6d8c761d0c99237369f6834" => :high_sierra
    sha256 "df952789786eaa259b98a6ba27bdd71786c7fe0d76510992299b1bb82a2a44c2" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
