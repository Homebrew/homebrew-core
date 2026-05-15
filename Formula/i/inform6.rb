class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.44-r3.tar.gz"
  version "6.44-r3"
  sha256 "3553b56ef0d1750a30924afab41843633bbbc8b3dde3b5da4ce5c18af189a659"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "536f547f4d23effc591bb1d7fda6c0067769c98065b2f1f676eff6abbf35c3f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8189f817a8805886898369cca0eb93e873033ed461651b2bcfdc894f905dca8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d68160fd397ea60b4939fd6a9c2428f2b4d266b40eb71c5075fe02c0d9ef7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e8bde5c949ae24843776de2d1d227e1d58e92eadd13f7827282be194a8a0a51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c59e1d517a7cf05e19e5387e52a299a58886d58929e4c37d1e1ac10270bdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1416257f1744dd78d0f252e4e02a4d30275227ad28b46f7253eae8820bbefc1"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
      sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
    end

    resource("homebrew-test_resource").stage do
      system bin/"inform", "Adventureland.inf"
      assert_path_exists Pathname.pwd/"Adventureland.z5"
    end
  end
end
