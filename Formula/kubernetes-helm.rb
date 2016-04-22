class KubernetesHelm < Formula
  desc "The package manager for Kubernetes"
  homepage "https://helm.sh"
  url "https://github.com/helm/helm/archive/0.6.0.tar.gz"
  sha256 "6582f095af305504132c45fba28548b0bb49da51d2f7ac20a89a324606719ed1"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc90eb9f1d14c7d8059c199a1d6f10376f5266cffac489ba4430594ee3602a15" => :el_capitan
    sha256 "046559b6b28c6c4e1de3a7638d3fc8f22d66e69e474825ff0db3ff5f5daf3fbb" => :yosemite
    sha256 "c1f65e57f5688ea4212d4c1dbb0a442820126415e7523abdf68311ad253d0e7b" => :mavericks
  end

  depends_on :hg
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p buildpath/"src/github.com/helm/"
    ln_sf buildpath, buildpath/"src/github.com/helm/helm"

    cd "src/github.com/helm/helm" do
      system "make", "bootstrap"
      system "make", "build", "VERSION=#{version}"
      bin.install "bin/helm"
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory?("#{testpath}/.helm/workspace/charts/foo")
  end
end
