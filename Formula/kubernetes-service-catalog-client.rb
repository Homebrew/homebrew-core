class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog/archive/v0.3.0.tar.gz"
  sha256 "3f79365cbe9c63513ddf3ad836177f0bd9ecee5b36cad015a3e9353e47cc874e"

  bottle do
    cellar :any_skip_relocation
    sha256 "fab55f3ff9b603beae7a4f8a5c0ea79cd3c4a24a821b4249dc2f9d2c345fa094" => :catalina
    sha256 "c1107702caae510cb024520cd793a999581d7133159a03d84e727198e34fda8e" => :mojave
    sha256 "dc5468299aea99767c0fdd5d7da91fdde53bee5b44d012476ead31c5d2288e2a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/kubernetes-sigs/service-catalog/pkg.VERSION=v#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-o",
            bin/"svcat", "./cmd/svcat"
    prefix.install_metafiles
  end

  test do
    version_output = shell_output("#{bin}/svcat version --client 2>&1", 1)
    assert_match "Error: could not get Kubernetes config for context", version_output
  end
end
