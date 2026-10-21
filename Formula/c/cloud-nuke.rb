class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "f620a5ecafad7e16acb929582e9653d2063fa323ec0a421dd7c9fe46739a3942"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27a229d18d20696a30a1d1fb1534a884c52a4be611103c483d7c9942acbc3a8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27a229d18d20696a30a1d1fb1534a884c52a4be611103c483d7c9942acbc3a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27a229d18d20696a30a1d1fb1534a884c52a4be611103c483d7c9942acbc3a8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c827358501fa098d400f70e87370418ba9b916fbf9387c2ca1fd4deb3f10de0"
    sha256 cellar: :any,                 x86_64_linux:      "0d941b40d097b446bc3852a76a75e05f8bc8f211635b9184b1ae56a5196dc407"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
