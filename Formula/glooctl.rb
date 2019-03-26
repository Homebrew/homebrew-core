class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.13.1",
      :revision => "d1f482db4b8dd1926c3d419829c55882f45b3ca8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f50fd887e7a864f95c778af1786641481d2882813f6ff95e043a862837330e3a" => :mojave
    sha256 "61a611674b4b37c464b53ef49f294008d03d0e5727592f80942c0b84ec6c3fdc" => :high_sierra
    sha256 "76228e40c220fedc0cd781cc25bfc834c5b0c697d2d3245d97c039235767bd54" => :sierra
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
