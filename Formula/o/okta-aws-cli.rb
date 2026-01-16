class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "d384489b3b1eff7e40df5f0f95261bf8dddd0e7916d28954ff490783141fa287"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ad772819bb6ad83c57c87822d410200627928d8d82f71c907edeecb7ed8a7ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad772819bb6ad83c57c87822d410200627928d8d82f71c907edeecb7ed8a7ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad772819bb6ad83c57c87822d410200627928d8d82f71c907edeecb7ed8a7ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a890a0bc52667d531355a344b0b877a103d43afb0d567236e212b2a775a6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "325e1371f1df291464c6b2306d8581425e5fedaed0c47276a5d839daa4aa2a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0fbbdaaf884202bf7a25da03a57668346deda8653a235b3598d6dc5df1579dc"
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
