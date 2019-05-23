class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag      => "v0.2.0",
      :revision => "ab3bc6c3e6da3a53c000f7744fd05a13b20189e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd08bf01c8afb0468d65d37b1c166e68ad4d77133894e036312e6ea103d20e3c" => :mojave
    sha256 "07e93e9006690c9017ac2a8b4ab7693ef12eb72f2d4b83de6288ac1a6395fa2c" => :high_sierra
    sha256 "e97ab9f2ddbbf29f13e70595d5dfe41930335b3053d376b7e6ca9c0a92f1fdc8" => :sierra
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
