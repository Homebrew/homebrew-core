class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r1.tar.gz"
  version "6.42-r1"
  sha256 "25968c840e0cf9f0e0939dad582268906f49fdad7e1501cbefe571013e0f810a"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "324499e408a1dfc47e64dee9d2cf645e985366621367667b3ca452dfcdcf77d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88c5c37d241f3169bf2c50efac01a3526f2485fd7fb772f2fc29cb597fb7f848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8148f5d7163d0fbdd79970cea9029096b0aba6669594a96b0fdb1679c4efe17"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcf6c3cf5b6618ac5853071e9053b783d98535c980fa189b9154e464c174d394"
    sha256 cellar: :any_skip_relocation, ventura:        "853644b80084e5384dd4d9a7b6f09dde50b6572be23c2dcc6c715e88fbb96931"
    sha256 cellar: :any_skip_relocation, monterey:       "8c7e258ceae325a06907d82a32e63cb56bb39fe41eda6d35b2c50b15f5bd0f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6280dececade4695c3560890475b15f39c38499bd32756d22c3ee4942a5f91b"
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
