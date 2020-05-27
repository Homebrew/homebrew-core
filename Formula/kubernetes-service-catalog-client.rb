class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog.git",
      :tag      => "v0.2.3",
      :revision => "62201e94f74962ff94dba0664e5e9e757c58188a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fab55f3ff9b603beae7a4f8a5c0ea79cd3c4a24a821b4249dc2f9d2c345fa094" => :catalina
    sha256 "c1107702caae510cb024520cd793a999581d7133159a03d84e727198e34fda8e" => :mojave
    sha256 "dc5468299aea99767c0fdd5d7da91fdde53bee5b44d012476ead31c5d2288e2a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["NO_DOCKER"] = "1"

    dir = buildpath/"src/github.com/kubernetes-sigs/service-catalog"
    dir.install buildpath.children

    cd dir do
      ldflags = %W[
        -s -w -X
        github.com/kubernetes-sigs/service-catalog/pkg.VERSION=v#{version}
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
