class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag      => "v0.1.36",
      :revision => "58b88f4d33cb708e4b22c39ccbe498b00738488e"

  bottle do
    cellar :any_skip_relocation
    sha256 "541d3fe04ab14a4fd4bbd305510a3cda162218031df669370489537a8838934e" => :mojave
    sha256 "2137298e01c7c1b56ee3fa7701fa9bf8218c85b36be20547b28b12c5bb7d7e5c" => :high_sierra
    sha256 "637f06c549ad751158b99a147496f32a34eb027386d6331143a037e97fcf4e22" => :sierra
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
