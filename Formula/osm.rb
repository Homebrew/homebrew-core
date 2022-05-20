class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.1.1",
      revision: "407bbedd5edb6ff9f1f51a4cabb95bedeb567312"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd08295d2f98652d45bea238a4a1ed03553f61e075344093a99ade23b8e2e26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81172012cc84f14efc38ace7890a7659eda7fda73e4917b327c5a594726dd2e6"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb4b1e2cff02963938905fe37d2bdfe4245bb7646a5f3b608a77a690b908ad8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf8152d718cf3c29a8b29326899ffdfad0bcd0c98211cacf38497fbc0f7252b4"
    sha256 cellar: :any_skip_relocation, catalina:       "23118bbcecbfc1f171e79be9e568a9f371b2e4efcfde0dd1745e06804575ffd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3051189b1dcac96851d280d64f5f79db40d42a848c36f82762b55d1020d262b0"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
