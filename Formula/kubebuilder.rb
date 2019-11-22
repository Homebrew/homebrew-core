class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.2.0",
      :revision => "0824a139f59e109c9e418a0b6e71a53c6e9e144f"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "051043567cef8d39e55adfefab1d703831a26a4474d8a218f290c550069c4759" => :catalina
    sha256 "32ab8d66024bf3f65d93d530ea418aeb3e8a4eca74b425a55f9f62bd2a8dcd49" => :mojave
    sha256 "b7e50da13d190cb07d0d3c30a36cd7d084bd782481c48a83f5d48c8dedb4c091" => :high_sierra
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
