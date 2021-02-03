class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.3.1.tar.gz"
  sha256 "0ef5b38c83acf008c5e0367710d4b20981b19f04d8129e1ab1f0ade1735d34cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f89c53afa445e2b212f28bb247639da1b4b8faef876bcf3297a05c7f8f134da7"
    sha256 cellar: :any_skip_relocation, catalina: "05813efabc5842c7a36689efad64ea531ec0f48943a7f34b847b4198c3ab40a8"
    sha256 cellar: :any_skip_relocation, mojave:   "0890fa0da64601b2d6046357e3598b7ba3c45da3f30359169e6d73f597d05205"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/cloudskiff/driftctl/build.env=release
             -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}",
             *std_go_args
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
