class GlooCtl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.8.3",
      :revision => "0e749d0fd9b41f8606dca85b70f0a9981cb0d5ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "f02d27980329ca2062f7e40d25039ba12ff742df29673cd5c863f0e8412bb7ad" => :mojave
    sha256 "94e899341c9ff3de2063edf03d9268eb3653f3b6062c3406f07815f3bf354086" => :high_sierra
    sha256 "b88446a61f585fafe883b516f349fd4c33b5d39acbafbf9f7e11da084b1f5014" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "glooctl", "TAGGED_VERSION=v#{version}", "RELEASE=false"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl --version 2>&1")
    assert_match "glooctl version #{version}", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
