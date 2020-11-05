class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog/archive/v0.3.1.tar.gz"
  sha256 "5b463be2102b32bd5a5fed5d433ef53da4d1f70bf007b5a4b78eee7024ca52e3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d17afa1cc5c192ba9ff73777a71d288744b52f08d49c3ca3eb0b57d46f529873" => :catalina
    sha256 "0fc4e96709b5f3a71afe4a526e70842b28b5aad677af9c6de7f3dcc62b94d891" => :mojave
    sha256 "4dda09b950c138a452a3a66d6742ef912761ac0365cc725ca9fad39189496690" => :high_sierra
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
