class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog.git",
      :tag      => "v0.2.3",
      :revision => "62201e94f74962ff94dba0664e5e9e757c58188a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c449e0cae42f826c443fb72d6e09297f622ca5637205366e9749089c375110eb" => :catalina
    sha256 "7dbf67eeb6b82c0c75b4efa8ceb82dd764260c1c6081ae808699f82593ea6111" => :mojave
    sha256 "f1744ab04a203c8ad1ce9d1a924ccc523fa5218d444348d542fffc2d462254c7" => :high_sierra
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
