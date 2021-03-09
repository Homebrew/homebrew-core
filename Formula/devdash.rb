class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.4.2.tar.gz"
  sha256 "88aa71141a5642fde2f56e773702e027ce35ee2e3d3492ad4747779e549f7da9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cb91a37df9360fcd5905277eb435d739cccf1c00a7bd91e2bd76009c63ea837"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed3cdf57da86291e75676b7b612c455a76a103a5ccba69a59bf5a2ab4ccdab2b"
    sha256 cellar: :any_skip_relocation, catalina:      "b52acde2aef763abf398625151e9291b14a65e440e6be766b641fbd2a8e08b1c"
    sha256 cellar: :any_skip_relocation, mojave:        "e8957a8a3223f928218c5b4fd37b6c8c9a6b37c9c68be2689ad4ec569259d6b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"devdash", "-h"
  end
end
