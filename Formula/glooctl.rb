class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.10.3",
      :revision => "a3cee406472eeacad8c891289d3d20e9e7b93e23"

  bottle do
    cellar :any_skip_relocation
    sha256 "520b0de00874e0f984c6d93e14b0b94afd2940cb7273ea2c4c5beb58bb744b0d" => :mojave
    sha256 "9465916ae5d7f0419dea807122424859fd97f2721af99c13bfe6355bf7497085" => :high_sierra
    sha256 "fd834d56cc95ec3bcfff35796b0fac3e257d7c3fad2c4f15754a0e71204556d1" => :sierra
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
