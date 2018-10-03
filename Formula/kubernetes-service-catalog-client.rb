class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag => "v0.1.34",
      :revision => "9a11d65cffff657bebf09ec7cbfdc4e5cd768628"

  bottle do
    cellar :any_skip_relocation
    sha256 "26ccfcea59f4031d8de0b2dd351ad0b3713547bb715352600bf580ef5e23792d" => :mojave
    sha256 "fa04b429be35677403bace97b1d50039393cb158aafe4a0665e7c3d6dcaa2ab9" => :high_sierra
    sha256 "9ef749d8f7be7b1e1d3ad87e6df26f27392c16684952f266aa34f24a8fc5e4ea" => :sierra
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
