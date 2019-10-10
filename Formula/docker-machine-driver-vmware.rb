class DockerMachineDriverVmware < Formula
  desc "VMware Fusion & Workstation docker-machine driver"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
    :tag      => "v0.1.1",
    :revision => "cd992887ede19ae63e030c63dda5593f19ed569c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d73c0be19fba7a7166c65202133b18c63367b5758d04ec19e23d3fd9406a8a7a" => :catalina
    sha256 "df81e5c14ec3961d53f6490a165a17b8ceda29beba747ee659b57d82a9468e26" => :mojave
    sha256 "e65553889741f8c077de12706314e9f95805d673b186d1d545617515d7ab4a03" => :high_sierra
    sha256 "4901f8daf5bc087b0b4bb64a2798696604e618b8d11433b6fa851dd90fd1b77f" => :sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

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
