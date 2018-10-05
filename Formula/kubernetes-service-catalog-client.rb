class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag => "v0.1.35",
      :revision => "f3a7a072ac60d9ccb7bd55b05ada0de18db3cab1"

  bottle do
    cellar :any_skip_relocation
    sha256 "843c41984743f6f838fb2e32cd3750057afb91416cd77f54266cccd776e8fdd7" => :mojave
    sha256 "32119342c88acb9f02fd0cac826ad2e1f96ff402262d6ed6433f783c42ce56eb" => :high_sierra
    sha256 "09f733a796e9691b229aa322a494782bfa56a378c20e03e80ef4177f9943cf58" => :sierra
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
