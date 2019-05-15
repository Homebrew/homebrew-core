class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag      => "v0.2.0",
      :revision => "ab3bc6c3e6da3a53c000f7744fd05a13b20189e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0e4a3a5a59a0942768f5e3f778fcd6e80fc86203eaf39ff798864a2d64423d7" => :mojave
    sha256 "31f088e2d70295d9978563709139b0f9b5957ed4157091ef5ea6846af5953774" => :high_sierra
    sha256 "6229632007c2b66c8ae4cfb1fa559c2fdbfd15f2da27a9c7ebd31ec72699f2cf" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["NO_DOCKER"] = "1"

    dir = buildpath/"src/github.com/kubernetes-incubator/service-catalog"
    dir.install buildpath.children

    cd dir do
      ldflags = %W[
        -s -w -X
        github.com/kubernetes-incubator/service-catalog/pkg.VERSION=v#{version}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o",
             bin/"svcat", "./cmd/svcat"
      prefix.install_metafiles
    end
  end

  test do
    version_output = shell_output("#{bin}/svcat version --client 2>&1")
    assert_match "Client Version: v#{version}", version_output
  end
end
