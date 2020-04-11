class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v1.3.20",
      :revision => "57e4bb83c0d13123b79a14b8536aad31c9d430a4"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09ae62140cb6286e66ac043e053c4f3ebeef1fccc067326d58269d8fb00149b3" => :catalina
    sha256 "6e5d3e48a1a07be525a85a09e8bb9894c1c5767d1d9592373d7e5d99b667a3d0" => :mojave
    sha256 "f2b06c92c9e47963b36a32cff3aff57590da729279aaf42ec3790faeb0c9c5a4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
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
    assert_match "failed to create kube client", status_output
  end
end
