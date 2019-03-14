class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.10.4",
      :revision => "18afa0fe738d3e6b593e8f16f665eede788fe9b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7adc537dd3c596dfd60c346a06eb30ca84e3ebadd094d09a97b36b3a8f7aa285" => :mojave
    sha256 "21e5e263e9890103ebef778cae960c3bd4efa8628c800410445acbbe45fa6c6d" => :high_sierra
    sha256 "f207b55b4dfb0a832f6b5e78cb89844bbbb6e628ae07bd0c9e5101b98509e47e" => :sierra
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
