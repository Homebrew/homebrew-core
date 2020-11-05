class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog/archive/v0.3.1.chart.tar.gz"
  version "0.3.1.chart"
  sha256 "3bb35a861e65f5d6aa93a2e525aabe33608090d8b2bb40524efb8a918bdb5f6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6f26e163ee15f601fef1b974e3c55f22a4c7333aea3ddf6ce009f386b58db18" => :catalina
    sha256 "9d29ae7fed57216e663459a4964c9946475329bdd4a6aa0666d69019840c6abf" => :mojave
    sha256 "a6b37292f716de1ba860d6e38905aa80063120ca8018d58b0bd05bca7475a253" => :high_sierra
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
