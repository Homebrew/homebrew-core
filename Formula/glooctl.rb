class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.11.2",
      :revision => "3c5c816a862e1f4dc5df19b9238640a1f78df608"

  bottle do
    cellar :any_skip_relocation
    sha256 "03f693507be1ea62ab5d79375dbf8fc0b283e0d3c7a3328f72c548fed1566352" => :mojave
    sha256 "5aa27ec2e78a4f31243ad83226703de267ab931a77fc5b674ba3de6690e42103" => :high_sierra
    sha256 "984e72f040200c68880cf39aa3304b56251e3df4946693ec09feecc700ab511a" => :sierra
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
