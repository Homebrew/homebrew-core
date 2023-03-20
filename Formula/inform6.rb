class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r3.tar.gz"
  version "6.41-r3"
  sha256 "3ea7cf46729bd030fb9354bf2a7b75a33954e7b2d0a359908d53a4b982be8412"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efd8ed1a537a0a1b9ab48f07e5ec4ef1e78b229d8d983237bf1a3e1561d63c08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559b54014ba66fe2b189b6da931e15307f5f3d96ffb6658d0a9619d281a76f2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80b4f1f548ec4c64bd1263b1c245da84d00f9050c2c1a838f563e0ffb6a22328"
    sha256 cellar: :any_skip_relocation, ventura:        "a9be03439680e35a30a9a48a670c161f381b52b65ae4962d89c4edc0de8f8261"
    sha256 cellar: :any_skip_relocation, monterey:       "8d214a6bbdf9a73c7064af7605363dfe460fd4aaadc5ca1bccd7fbfc3895a18d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6f0712ee230c260244acc7a3e98de3a2dde50533e3953187cbb2d0d60de67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d84b546b5777c1e7b70f83413dad0ce024f9645ab48936bdd714994f82e526"
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
