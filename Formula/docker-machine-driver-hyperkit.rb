class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/machine-drivers/docker-machine-driver-hyperkit"
  url "https://github.com/machine-drivers/docker-machine-driver-hyperkit.git",
    :tag => "v1.0.0",
    :revision => "88bae774eacefa283ef549f6ea6bc202d97ca07a"

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/machine-drivers/docker-machine-driver-hyperkit").install buildpath.children
    cd "src/github.com/machine-drivers/docker-machine-driver-hyperkit" do
      system "dep", "ensure"
      system "go", "build", "-o", "#{bin}/docker-machine-driver-hyperkit",
             "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
        sudo chown root:wheel #{opt_prefix}/bin/docker-machine-driver-hyperkit
        sudo chmod u+s #{opt_prefix}/bin/docker-machine-driver-hyperkit
    EOS
  end

  test do
    assert_match "engine-env",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver hyperkit -h")
  end
end
