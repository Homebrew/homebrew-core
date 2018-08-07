class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag => "v0.1.28",
      :revision => "0aaf02aba556b945a357fce4e82f62122d158f2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "248125a777509f0c94f9825d2b22ea0f8f756507ce598acedfecded19d165f7a" => :high_sierra
    sha256 "130114ff4eb4007d2d4a8399a23867e61b749e714357db30cc66cc4bfa85b3d4" => :sierra
    sha256 "280d41bc66799984f7082c4b8a911235d069beec2b39991ec5fd712284238100" => :el_capitan
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
