class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.11.1",
      :revision => "f5cf4d472a64bfacd8291ff91543e2b2a8978084"

  bottle do
    cellar :any_skip_relocation
    sha256 "792d7028ff5e2760e88aec0c8d36af794161b4e00eb1a889068511414eed0534" => :mojave
    sha256 "61ba90636f7d68ac84eefc8a92e7db3e04776677ab363800e7b9803d76be1bf8" => :high_sierra
    sha256 "6a538d192537022b114b5aa3ce6de00c9ca69f934a892c9ebdd0f01a21affc37" => :sierra
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
