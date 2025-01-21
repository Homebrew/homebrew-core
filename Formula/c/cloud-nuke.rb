class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "83c243c103f9c48e02717440ad1379c83261d739c82d61fc337297b14546dc9e"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78d6b1b53b0e1c935d5eecc318c28f76ae17418cf771f20e5976eca0f5029a07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d6b1b53b0e1c935d5eecc318c28f76ae17418cf771f20e5976eca0f5029a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78d6b1b53b0e1c935d5eecc318c28f76ae17418cf771f20e5976eca0f5029a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "84bcc0c34d8c009a00721470dcfc57246c72d54ebe7572ef153470c14fc4c709"
    sha256 cellar: :any_skip_relocation, ventura:       "84bcc0c34d8c009a00721470dcfc57246c72d54ebe7572ef153470c14fc4c709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bade8ba0af2e83e64a236dda68eacf79cb38611c337649fd3006617ced00efe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
