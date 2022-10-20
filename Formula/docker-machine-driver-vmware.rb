class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
      tag:      "v0.1.5",
      revision: "faa4b93573820340d44333ffab35e2beee3f984a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8435fdd294f5ada321d652dec3eba0a01811576074e9d169b96d4bedcb31c630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51441771e510e3263cfddbefe03c1306bd971624e35d5a44a3a8acb37be141c6"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa978d59f3f647229527029ab3a3a88fdd3bed7d7000214969acf218fc1d084"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4cc3a076070538c9bacec55e70ed2fd454f860c5c3c9a5f3f1986abb8c7be88"
    sha256 cellar: :any_skip_relocation, catalina:       "29427b8c6e0c23160406ffbd642c5838cf6e2d2e73de30c688630ae60f57f47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2699119a539f3b9b7c86f900d5510d5b4cdb952ebdc60b7f5c12bf80f5d4932"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "docker-machine"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver vmware -h")
    assert_match "engine-env", output
  end
end
