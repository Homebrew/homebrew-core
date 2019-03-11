class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.10.3",
      :revision => "a3cee406472eeacad8c891289d3d20e9e7b93e23"

  bottle do
    cellar :any_skip_relocation
    sha256 "eccb9830426ec262b4180d2edfb2fa252130a4099f40f893dddf63b251e79869" => :mojave
    sha256 "d3bcc7485ea82efc8301f9f9edc573b6b231e241896debe511c66d73013ffd82" => :high_sierra
    sha256 "6096ea921583052fc5ae3a30309a10917f33c1c42a56bf8461afd8d07abb3e38" => :sierra
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
