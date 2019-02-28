class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag      => "v0.1.38",
      :revision => "19c1ae7eba0f132641a23cfa939ab141d6070a06"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6e1437c5fbc8708235d4ce3d5dd30c03f38b53bcdcb4f6277c63e405ed63cb9" => :mojave
    sha256 "b2f40b2d3fc92f7e8d76f66d5ebf64df2a83fa1a079cec9144e936bddaa759c9" => :high_sierra
    sha256 "e1aa4d2203d37f0de5ac0cb19c4059c8f8feb5e851b6f5697f89c0162365d8c5" => :sierra
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
