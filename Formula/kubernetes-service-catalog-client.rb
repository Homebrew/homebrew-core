class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag      => "v0.1.37",
      :revision => "c6a2cefe71c6a57f01ec1bab46c54b49f48c1c89"

  bottle do
    cellar :any_skip_relocation
    sha256 "f91a6d4d9aa8cf8d1563da8eacf5d5d185a3fc54fb1f2c2c1c0a88012468476d" => :mojave
    sha256 "a77f66fa06594b00b39a51804e10baa0e91c593cb4fdb6538f59718b102be47b" => :high_sierra
    sha256 "70007b5fafc3fd058f2ea91fd72745cd91db5e0eccbeb15caca81cf32001fa68" => :sierra
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
