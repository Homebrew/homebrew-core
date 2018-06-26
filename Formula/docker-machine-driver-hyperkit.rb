class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/kubernetes/minikube"
  url "https://github.com/kubernetes/minikube.git",
    :tag => "v0.28.0",
    :revision => "80e934b8450578c2ac24d6b9c9fe2b42dc4b0d93"

  depends_on "go" => :build
  depends_on :macos => :yosemite
  depends_on "docker-machine" => :recommended

  def install
    ENV["GOPATH"] = buildpath
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
