class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.0.1",
      :revision => "855513fa7eec932f8fcd1c28c02a139c222413af"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "498d0f343a8fa2c1d6136c34b8f1c22442e1d4b79e860d5d6e487411f3035ddd" => :catalina
    sha256 "572f64125683f3e1c13d49261b233ec86af53d5bffe474525deede3991ce3eeb" => :mojave
    sha256 "2af2915933b0f36ecbd7056da6bb36d6083c37ed12ff324402c129aaf0e11616" => :high_sierra
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
