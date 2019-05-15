class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.13.28",
      :revision => "be0d6b52cc4ef332ebf2622cb5b56abb04ca7da4"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a075f402de5f769fc00dee79465118e7bd721eaa33589134a1e81e6ee0b294b" => :mojave
    sha256 "dbd804402882229f989447eef10cc245c0de23280d4ece38c56aea2b5b16c21b" => :high_sierra
    sha256 "8044a8da20fc81b5429243dd90e0f6ab4a049d78bdcd3cb1dda43bfb4708e8e6" => :sierra
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
