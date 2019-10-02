class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.0.1",
      :revision => "855513fa7eec932f8fcd1c28c02a139c222413af"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae9ae8bf951b3309b17de6a07b9f8ad70fd6e28cf78ab6dffc70cef3a9698568" => :mojave
    sha256 "a0c168e5d27277331877642f0fc5e320847e4b441a342c5c2a2f56ea24dc26e2" => :high_sierra
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/sigs.k8s.io/kubebuilder"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Make binary
      system "make", "build"
      bin.install "bin/kubebuilder"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/kubebuilder", "init",
      "--repo=github.com/example/example-repo", "--domain=example.com",
      "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
  end
end
