class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/kubernetes/minikube"
  url "https://github.com/kubernetes/minikube.git",
    :tag => "v0.27.0",
    :revision => "a7c0cbee11dd97f257cc8d050605684c0c446a7e"

  depends_on "go" => :build
  depends_on :macos => :yosemite
  depends_on "docker-machine" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "1"
    (buildpath/"src/k8s.io/minikube").install buildpath.children
    cd "src/k8s.io/minikube" do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-hyperkit", "-ldflags",
             "-X main.version=#{version}", "k8s.io/minikube/cmd/drivers/hyperkit"
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
