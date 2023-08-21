class BzrExtmerge < Formula
  desc "External merge tool support for Bazaar"
  homepage "https://launchpad.net/bzr-extmerge"
  url "https://launchpad.net/bzr-extmerge/trunk/1.0.0/+download/bzr-extmerge-1.0.0.tar.gz"
  sha256 "1b86d3a54fe669db19bc2a42a09eae52e449cc3ece8234377fd213e834f69cc0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8aa67f424683414f0e2553170e9835caf54aad70e99517ad79da66a46c3ff6bd"
  end

  disable! date: "2022-10-19", because: :unsupported

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/extmerge").install Dir["*"]
  end

  test do
    assert_match "Calls an external merge program", shell_output("bzr help extmerge")
  end
end
