class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/machine-drivers/docker-machine-driver-hyperkit"
  url "https://github.com/machine-drivers/docker-machine-driver-hyperkit.git",
      :tag => "v1.0.0",
      :revision => "88bae774eacefa283ef549f6ea6bc202d97ca07a"

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "docker-machine"
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-hyperkit"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "#{bin}/docker-machine-driver-hyperkit",
             "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute:
      sudo chown root:wheel #{opt_bin}/docker-machine-driver-hyperkit
      sudo chmod u+s #{opt_bin}/docker-machine-driver-hyperkit
  EOS
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver hyperkit -h")
    assert_match "engine-env", output
  end
end
