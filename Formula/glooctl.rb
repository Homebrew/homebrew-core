class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.13.7",
      :revision => "6f52c7c8afa0249c7887c0ed4376feb922db53aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b64d0707e403f292db484467ae7923bdba4741b2250655be23da4bc4f7f4c7d" => :mojave
    sha256 "93d00cf06e42cce4f20b488ffae02012c0b43209486f95a16882c64908a6a5cc" => :high_sierra
    sha256 "331973eee922843f1be14f8f747aeb05ed155d67c262e8fa613a7c2ef2a02b41" => :sierra
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
