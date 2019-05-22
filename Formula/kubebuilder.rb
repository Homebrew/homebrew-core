class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.0.0-alpha.1",
      :revision => "a39cc1a586046d50a74455da6c44da734d2fb8fc"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/kubernetes-sigs/kubebuilder"
    dir.install buildpath.children

    cd dir do
      # Make binary
      system "make", "build"
      bin.install "bin/kubebuilder"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GOPATH"] = testpath
    ENV["GO111MODULE"] = "on"
    dir = testpath/"src/example.com/test-kubebuilder"
    dir.mkpath

    run_output = shell_output("#{bin}/kubebuilder 2>&1")
    assert_match "Development kit for building Kubernetes extensions and tools.", run_output

    version_output = shell_output("#{bin}/kubebuilder version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
