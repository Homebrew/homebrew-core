class KubernetesServiceCatalogClient < Formula
  desc "Consume Services in k8s using the OSB API"
  homepage "https://svc-cat.io/"
  url "https://github.com/kubernetes-sigs/service-catalog.git",
      :tag      => "v0.2.2",
      :revision => "f3e67cc3e70d266e643d391e43b1bdd31cdad448"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4bf12de31b55fee78198b7e14dc3c25422ebb42fd0c0650c05b198e31306fd2" => :mojave
    sha256 "9d95067633dd38e7b363813c5adfaaac2ba54eff44bef194d543573db631e44a" => :high_sierra
    sha256 "a5180879af829ddca41d66ed05549ef958f93b433e21f3d7de2c797d03d58f16" => :sierra
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
