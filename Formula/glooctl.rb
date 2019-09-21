class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.19.1",
      :revision => "1539067a393f53a0b793106aaa4676f8ff87df99"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e382beca74edc829d90765fe0420049592bd425f671f0f8275bc80c4b9d426dd" => :mojave
    sha256 "077c6d350b19375ab180a83aa6eb7024aaf4e2cd5478dccd6f2e901752b140fc" => :high_sierra
    sha256 "5b25bf73b8fa785b855f193cf6e422055a56f7fc181cb8c6aaeacc83a794bf52" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "glooctl", "TAGGED_VERSION=v#{version}"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl --version 2>&1")
    assert_match "glooctl community edition version #{version}", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
