class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.10.5",
      :revision => "44cbc55c048270317200eb3eab500bfe585392b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "190a0d7cd3f9fc8966639dd55314d96f0a0ac215fa9b5a0f1545b39c2b8fa1b7" => :mojave
    sha256 "f140a7ef573116eee56bb5a9b1d6efc9e046091e75c271d853c5075f03a37dde" => :high_sierra
    sha256 "d14694c4d86e95fd00dd8c223fe2368eccc10ee5778e102d40ae2c0e4c5dff62" => :sierra
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
