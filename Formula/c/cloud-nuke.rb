class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "e735eb9e568d5cbc23b9ed348f36a5ae8cb05b649f0608a2b5da9af0a665f3c6"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c2ce9d0f48bdccb4fe31845774ae202977f1212978f8fd0095fe6968e7cdd7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c2ce9d0f48bdccb4fe31845774ae202977f1212978f8fd0095fe6968e7cdd7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2ce9d0f48bdccb4fe31845774ae202977f1212978f8fd0095fe6968e7cdd7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b711b91903d25d10c42c93c0e1a8fdd41e69e2625fc6cd5b8d71eca9d546716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de812717122619f1c5cce78037b06bb51e52210685af2d11e6945b424c49893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5da0946d1e117bcba6293d61c3b70eeb6d75d93a2b893492586ebad4e4c3007"
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
