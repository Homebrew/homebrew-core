class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r10.tar.gz"
  version "6.41-r10"
  sha256 "a36781a732dcccd8de0a3a04b59b0681fa1b1303d58f51449620ca0b9a8de879"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d77c3600c1a096a5f7670e0ad964e7d97d30caaa60958be6c991d4240ea6779d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f20f7fe4c9b81285e1cfa0edfad34abf5995dc96540efc1014b1cf76ca8af3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "641a5c13733d737f9b789e87f16ca87e6408af68c0aa75d73961075093ed786f"
    sha256 cellar: :any_skip_relocation, sonoma:         "203e6c82ddf3c49161a715a545184a4ee86c127bfde6b799e3fa859847c84e15"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a2b74e34b8486a56570451119d00623270d1e08d7a8c70aa5cd1e499a6e7f2"
    sha256 cellar: :any_skip_relocation, monterey:       "47a4f02482838c5def370be8b51aed96dcad714981a4b93ebd876eae83e5ca07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af654756fdd9084654127e0b31c1edfb68864e13a16b8e813ae86003478d1a9"
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
