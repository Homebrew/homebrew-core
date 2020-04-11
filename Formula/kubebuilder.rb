class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.3.1",
      :revision => "8b53abeb4280186e494b726edf8f54ca7aa64a49"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1e36d2456c8b998ac206eea2285056ab96f413c489328876ac21a14feb031bc3" => :catalina
    sha256 "fd4ea19043bac99346e055a43f7663e36e0b4053b95a883772e65713a0547ccb" => :mojave
    sha256 "ff71790d113a8fee329e0e908e6a4b3e4f0db929b4ebf04a1b641d91899ac546" => :high_sierra
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
