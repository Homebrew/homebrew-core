class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.18.21",
      :revision => "e45760101f7269ed8711a1b4ced13ec0cc04d74e"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f1a80429a983c49c07da716e3231fc638eee2579cb85896ebd049c34aa9b908" => :mojave
    sha256 "0c682ef276a8c87f577bf74c33fbdfe5ec11643e813187001f5f32998ba56d84" => :high_sierra
    sha256 "9cd45b1e08413ef83e0c495959acc5fa51f13577ac9bd4552399a4937104288b" => :sierra
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
