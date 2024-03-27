class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "e4e654d880cc8bf45b69242091236a1db8fd43056c589f0669a8aaffe2ea6d05"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c005a4382d22f78624a2de2f7f51e114780900b48fb9090a57f3d39659ab3d40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58665f7ecd5055c7d84b70d39acae42cf75971e851dfd1126e49cb26b7994a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe26c1c839ca8dcdd56afc542ccc774bd0547f739a84b91a579c4d048263ee5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "414b71890ba0487df6f22de62576e5c69deff767849ae24ebc4953ec1c3dd1f5"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab40931a94a71f8f32102c6273ac7b4c5e77d1b4356ce64c8320f5c358d7147"
    sha256 cellar: :any_skip_relocation, monterey:       "c99d7ed827ac523a3b28ac159c3393308bff89572e20d16c04c9258430e936e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c2617f5232f7523ac87ec077d8291427ff60c985cf889771393048c13f1f55"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
