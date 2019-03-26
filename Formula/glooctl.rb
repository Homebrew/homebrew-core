class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.13.1",
      :revision => "d1f482db4b8dd1926c3d419829c55882f45b3ca8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8870545eea44a25b8e9d90505c65b4fcaa9b1fd080ad2f1a251c8d9b29531fb" => :mojave
    sha256 "50692329da54f5f33d6d8604a9c507d61e924a74c76d995bd39acfe47de41b7b" => :high_sierra
    sha256 "23cc4cbb5eb199c097b7787a1552faefdaf9fbfa3cdaadc0cbfdd7dd0a34bb07" => :sierra
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
