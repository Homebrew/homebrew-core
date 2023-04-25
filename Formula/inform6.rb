class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r4.tar.gz"
  version "6.41-r4"
  sha256 "cb9e45ff357ff7d7d2e19213b4fb12824a4c35fa27173b5910ffd06714908df7"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25eba4436a8d796d55735073aa2ac014f2f6298822c7726e1465b97ce56a6cc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da175d9c1efc3a1fd047369bd9597450cd0b768a7aee66fc58899363fdf08ce9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ec2856e88fa78920a08ac3f94601434010781e232d137cb2ec8a4eae9e9db1d"
    sha256 cellar: :any_skip_relocation, ventura:        "09ddaf3b4567df6109b4c26f5803f402305a0bbe0c61d96cafbe3fb5fe68d100"
    sha256 cellar: :any_skip_relocation, monterey:       "d823205659e0837e9012a51de378360aec2e18c4de1926468b73d0984e3a0aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d36b42868f7a6943ce07d09300ecab00393b0e7ce92d22678a074dcab7067dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a24565f25dcd24ca25e68a8a02805bf0160731c724bbc82ec63cedd5feb07636"
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
