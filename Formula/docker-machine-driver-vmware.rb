class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
      tag:      "v0.1.3",
      revision: "fa87f07244c4fc64cde5f921ac9d0cb60cc3302a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e30f8a82609ed01ba4db77297a72a54058341349a546ef5926ce7d101ab3bacf"
    sha256 cellar: :any_skip_relocation, big_sur:       "06e7a06267df68d8200ff678cd9aeb4b214e839f6e8a59dad4617c8cf1d23696"
    sha256 cellar: :any_skip_relocation, catalina:      "d73c0be19fba7a7166c65202133b18c63367b5758d04ec19e23d3fd9406a8a7a"
    sha256 cellar: :any_skip_relocation, mojave:        "df81e5c14ec3961d53f6490a165a17b8ceda29beba747ee659b57d82a9468e26"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e65553889741f8c077de12706314e9f95805d673b186d1d545617515d7ab4a03"
    sha256 cellar: :any_skip_relocation, sierra:        "4901f8daf5bc087b0b4bb64a2798696604e618b8d11433b6fa851dd90fd1b77f"
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
