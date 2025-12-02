class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
      tag:      "v0.1.5",
      revision: "faa4b93573820340d44333ffab35e2beee3f984a"
  license "Apache-2.0"
  head "https://github.com/machine-drivers/docker-machine-driver-vmware.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "01fa7c87d4ba3e58db8cbc31e7b7f89d0a46d500d3e8d88431cd90f31e501ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3010bd538c1539f9c59681820e3c316c709c25af6f27a1832afa982cfc026646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81805da1dba151839c89b920d7c8690adfc56d57b37dd6c83a599b2d29d2d292"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "780fd9e178b5d74e3e0d8e9682460c01d22f53bf291bff09270ef600b758c4ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8435fdd294f5ada321d652dec3eba0a01811576074e9d169b96d4bedcb31c630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51441771e510e3263cfddbefe03c1306bd971624e35d5a44a3a8acb37be141c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d14214a8054e0c62a52853e889663be19897ef55d7a3fb9f5e7203ec309f7ce"
    sha256 cellar: :any_skip_relocation, ventura:        "e88d45b53c2fa8ca55a55f4e5bf0f793da4e8cbc0be4cd3109cb232a858586a1"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa978d59f3f647229527029ab3a3a88fdd3bed7d7000214969acf218fc1d084"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4cc3a076070538c9bacec55e70ed2fd454f860c5c3c9a5f3f1986abb8c7be88"
    sha256 cellar: :any_skip_relocation, catalina:       "29427b8c6e0c23160406ffbd642c5838cf6e2d2e73de30c688630ae60f57f47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5c76b201cac7373f70ffcd396af6f46fb90c49f5a103e9d6e44ddf50ada228e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2699119a539f3b9b7c86f900d5510d5b4cdb952ebdc60b7f5c12bf80f5d4932"
  end

  depends_on "go" => :build
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
