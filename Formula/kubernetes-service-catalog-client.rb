class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag => "v0.1.36",
      :revision => "58b88f4d33cb708e4b22c39ccbe498b00738488e"

  bottle do
    cellar :any_skip_relocation
    sha256 "514107a39e522c7013d6e4d7e5f611fff2224b909afeb7e9231a37d8671c98c5" => :mojave
    sha256 "d47d2d1258b3b7fa467ec71dc2ee3e725445909017b470c61110663bba525265" => :high_sierra
    sha256 "d90fbe717dd5486dda805ad916e735172339ada0d7fc31c735e10a7dc2716104" => :sierra
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
