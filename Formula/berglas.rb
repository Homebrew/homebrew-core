class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.6.1.tar.gz"
  sha256 "25896fa483895d4f79c30314df95c5afcbb1af2f92355ccabb5d58edb8c71ca5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713a1f10c5cdf4ab9ad5a51ea28b2f63aabaf6237c902cc00664c874ae150e87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efff48b9ecaaddbec4acb42e734cd9d20ac69ff99cdcee9da1038f4f528f5f70"
    sha256 cellar: :any_skip_relocation, monterey:       "f62bd04b32479c0a1b687adccf3e18329bb7a6d8eff68a1e71f2e1f7a9671d5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ad3b597268182525c38548ace467d29e38a3a321792b20ad6549818c2b36dc6"
    sha256 cellar: :any_skip_relocation, catalina:       "462ce1785b8978e6d3e40529895277ffaab10e0b6a6a4b73bfd73c59f59368d8"
    sha256 cellar: :any_skip_relocation, mojave:         "e415365e97979ea042b08f192621b660200cb184100a9fd28b58c1b2d0317113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cdb430cc5aa32e9192a22b54bbc25bec925110be518cd9b87f8a70dda969ea3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
