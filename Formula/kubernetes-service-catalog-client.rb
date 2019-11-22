class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog.git",
      :tag      => "v0.2.2",
      :revision => "f3e67cc3e70d266e643d391e43b1bdd31cdad448"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e45d39e10ea6755692a2a8726ea318375319a558957401b36e725acf03dc9c3" => :mojave
    sha256 "875af8928b5818e3951b25e1d6d05c6b491163f11036770c1cc290e8bbe82fe2" => :high_sierra
    sha256 "7d06fe9962debc87dbf3112b17c18d81002ef0c4b71ecc8844df53b827210500" => :sierra
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
