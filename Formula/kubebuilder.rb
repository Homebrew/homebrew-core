class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.1.0",
      :revision => "51b536013c61d87b19e0d3e1d498c4ff3db5bbcf"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9ced42c41cc779728cf88a265d6ccc779593d4fadc54e09a7875045ddd8eefb" => :catalina
    sha256 "7d080cf062c71c123368de823d1be821b7cc2c7f6f1cd447a605ce56f0d8984f" => :mojave
    sha256 "7bb90a95808e0340b38f9af6ee2ed3a4db3fc0ea88bfd6b25f8e292b217e1928" => :high_sierra
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
