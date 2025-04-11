class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "dff4578c0572ce76d4c567ab114ad8f346c570e82fbad319f4a5784b9231c4f8"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107cbec811d65d4095f9d84716183f08c5eeb6c0c8cf7857a7fc1cda5d6f37d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107cbec811d65d4095f9d84716183f08c5eeb6c0c8cf7857a7fc1cda5d6f37d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "107cbec811d65d4095f9d84716183f08c5eeb6c0c8cf7857a7fc1cda5d6f37d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62f8cf74290855aa37a79d13958e9ec90edec3b9fb3a472fa20ac73c4c84ed8"
    sha256 cellar: :any_skip_relocation, ventura:       "b62f8cf74290855aa37a79d13958e9ec90edec3b9fb3a472fa20ac73c4c84ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d3c4bad569a197addaf2839c094624097f51ac4fc40a5e5dfd8b923aa33927"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end
