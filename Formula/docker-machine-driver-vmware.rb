class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
      tag:      "v0.1.5",
      revision: "faa4b93573820340d44333ffab35e2beee3f984a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3522b431d33e08ad8254960584cb82125d3654ef0967e278351e28a1a9b87a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98cd633c17acd0978f43cb4d2f1443e6d21ad5acf56d93cf28c654f397791658"
    sha256 cellar: :any_skip_relocation, monterey:       "3a22d6d877b2412af488570396f84ee8f009eeaf0e12a773ee6af1eac7683418"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f7eef36f62d2b630deb5322a4f6b01e78d14e669fbfb88e352eb774e280dce6"
    sha256 cellar: :any_skip_relocation, catalina:       "4bc310cd17c2d0fd65a4c52c31950ff23de1c2d70dd18affa8d6f94328c6d6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcbbcda3d2fefbc6a36110af71741feca578e911bda0c54ba54ab9846e741dc4"
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-vmware"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-vmware",
            "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver vmware -h")
    assert_match "engine-env", output
  end
end
