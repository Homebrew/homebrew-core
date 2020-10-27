class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v2.3.1",
      revision: "8b53abeb4280186e494b726edf8f54ca7aa64a49"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b587ddd6d67b12a7fd2635f8f4da56402133a036fe79e635b08427b401a9b71b" => :catalina
    sha256 "7de399f00ecd47e3150e05d213a44886f499456ed5480c095100e329203ab399" => :mojave
    sha256 "62040031af53761dbe639796b5dc95278be2a048380f691563fb9cd4ef7f8041" => :high_sierra
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    system "make", "build"
    bin.install "bin/kubebuilder"
    prefix.install_metafiles
  end

  test do
    mkdir "test" do
      system "#{bin}/kubebuilder", "init",
        "--repo=github.com/example/example-repo", "--domain=example.com",
        "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
    end
  end
end
