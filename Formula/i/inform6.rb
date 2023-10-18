class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r6.tar.gz"
  version "6.41-r6"
  sha256 "609de4f5cfae611cc8e6f3333d7016bdb2e802fe39096c59db50c5b31e14b557"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "235f253e1b358f1b624ade58136cd00cb0161d654376f3e3ff6fdeaf703b9f56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f375c1af6d193350be16319b80c545e53985b38cdc1988939c191ce45478703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "364bd6fa090ec1ca128cf678e2066e1aa3620df42b6d2b8bcf955206b9baa157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "492008bc56dc0468c0994dac47501a91ee02d179d747544b7e1cd1183b785d9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7facb1374525c88c56a7ebf2ebb9acb3ba8c56cccccd28e91e8c4cf386289212"
    sha256 cellar: :any_skip_relocation, ventura:        "368a1105afc2be3fa8448b91ee93f1d4e13a90e7f2236711a1f1f6bd88662613"
    sha256 cellar: :any_skip_relocation, monterey:       "0aeaa2879d6ea06fb1373117115e239059da2ed04e68d9a647a13fcb34bea1e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c8ba8cad52b5652188721bb5c7a98b490d6f23f2479a374d8784b80cdd9fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74616af11d9700f2ca7f0de9661ace30b5883d728fbb8bc8b91cdca9ffdc5f77"
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
