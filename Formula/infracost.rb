class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.17.tar.gz"
  sha256 "f162ffa4871688a5aa3a0f5bbb6525b9e405c51352df16a9813d0692799c53d7"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9fa80aeec2edd1f4611dec1309138db2d39f0a1feac433b67e95853765c51fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9fa80aeec2edd1f4611dec1309138db2d39f0a1feac433b67e95853765c51fc"
    sha256 cellar: :any_skip_relocation, monterey:       "70320606b872a984f36a162c8e18c2034c7379791fe4025a073827164246dc36"
    sha256 cellar: :any_skip_relocation, big_sur:        "70320606b872a984f36a162c8e18c2034c7379791fe4025a073827164246dc36"
    sha256 cellar: :any_skip_relocation, catalina:       "70320606b872a984f36a162c8e18c2034c7379791fe4025a073827164246dc36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4c60e947efb7f5b7d40b25bbc0db48559d872babc9a57af3dca83e6de0178e"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
