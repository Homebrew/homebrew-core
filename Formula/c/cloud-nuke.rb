class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.32.0.tar.gz"
  sha256 "036bbd78926072b59462078f1821278599a20aef47872230b522baa29cd7259e"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "328966db70f18c35c88188df07af0574afaf6ffb874618bdfb336f0779486360"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd6a2949632107aa3e471a855c7bd461de1de78f063edc3ab4a9276230aa25a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6a2949632107aa3e471a855c7bd461de1de78f063edc3ab4a9276230aa25a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd6a2949632107aa3e471a855c7bd461de1de78f063edc3ab4a9276230aa25a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d9186eae8ac67d6c3ad29c9b37d0473f25fca988e22c55810fc3051b3391fde"
    sha256 cellar: :any_skip_relocation, ventura:        "516cf3ed18f08e4fc45e8de267ab70f5e2a1a42f7c51443507eda848e7534a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "516cf3ed18f08e4fc45e8de267ab70f5e2a1a42f7c51443507eda848e7534a8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "516cf3ed18f08e4fc45e8de267ab70f5e2a1a42f7c51443507eda848e7534a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d25c1b409cb90ddc41c5b659c6e4dcdf7de2be963800dd0db7b9feee81510fa"
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
