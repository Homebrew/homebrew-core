class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.36-r4.tar.gz"
  version "6.36-r4"
  sha256 "9becbad0cc737e993a5fc969b9ee9689781e3884658d52b17db68dad55010f2d"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8386cf374d8690cf513678d54dee79c616dec61e8afa802c50195786be46fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7fb9812fcb9ea6d4d15b66710346521f08f6c309b21cdf36a8b9eaf18ed947a"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a1d622812e76712f05ae8cd211a053f0b9bc6f35e3b2498afe2154c608e044"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a54cfbb593981d2320542a8f4d7809d3d041ca609de15e8557b80b780bd946d"
    sha256 cellar: :any_skip_relocation, catalina:       "359e10ec5b6956b1367c7d8e1aa93703260bdf010a14769acf8a4f718be79ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55a57d2b20c7f7330c8d91f4a6f99719c730e8f5b1d6eb3cda1f763554ea305"
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
