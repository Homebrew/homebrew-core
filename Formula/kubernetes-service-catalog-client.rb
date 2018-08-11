class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-incubator/service-catalog.git",
      :tag => "v0.1.29",
      :revision => "44182ac234fdf184a5dcca63d01c9f67a56c4e75"

  bottle do
    cellar :any_skip_relocation
    sha256 "70865c53c38986f5a3386852de79e1c8b2754628d5aaed25d090404304422cfa" => :high_sierra
    sha256 "e73f72d10abb1d3767ae5fb28670bd986c51a725b6e31fbe9b68ab5de9e37a69" => :sierra
    sha256 "9ae9dbce749bb8d57a7c21bb6d5431ae16d4e763ea82def2eeaf0e0d04e18e39" => :el_capitan
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
