class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag => "v0.1.33",
      :revision => "621d4e22f5fd6ad137d350e8122b59e01d0c3845"

  bottle do
    cellar :any_skip_relocation
    sha256 "3be9e859e57944388194b5b8ac3867736a3c201cc47cf22507e417f4c463c214" => :mojave
    sha256 "d11a1d9bbf17d49232ef3a527b5b01bc8547a02f895d5af12499b3c0c72298d3" => :high_sierra
    sha256 "66d9064fbd29f534d3d59177751e5ed3147951c14061cbf18528a3096b07c895" => :sierra
    sha256 "dbc775a46c731e48ac620fec57e9d9fdefe9ec4d127f4457491c7f557369aaa5" => :el_capitan
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
