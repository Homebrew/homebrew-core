class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.20.6",
      :revision => "3aa4e784c25c4ca632820c621c8d13aa111f155c"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3d4fa252f348ae2a317592d535abb6d7f0b972c2cd6b88c33275788023c2c33" => :catalina
    sha256 "71bcdcca0cbb5f4f331c8a1e9aa181a2342e1f89b32fb73789917ead163969b3" => :mojave
    sha256 "0afc156db4ec96d528bd82d86ac34dbd435c5ad3ae26f0a4daa03df03781a4df" => :high_sierra
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

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
