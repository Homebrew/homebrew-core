require "language/node"

class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.24.0",
      revision: "5a8648921cc2779eb62a0ac11147f12aa29f831c"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "779435947bf68cdda1fed06f6dc3986f6818afd6a4c71e42524d865dd2afb9b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b5920d5e5e9ca14e34d27d09fa32877f20818d136470896d1e2434f1e09aa3e"
    sha256 cellar: :any_skip_relocation, catalina:      "8e29c1b51ec3b2d1c9b5cdc0de357cd41851f4f0df42c07afe270b6078595cf4"
    sha256 cellar: :any_skip_relocation, mojave:        "e8d3d6fbaf7cd9f368ab7f010be4ce869e841aea1e124f7dd69ebcb98310eb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27709ab5ecfc271d40b1ff8c6f984b6edd9694bc5d2929023448d1a96544f37d"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["GOFLAGS"] = "-mod=vendor"

    Language::Node.setup_npm_environment

    system "go", "run", "build.go", "go-install"
    system "go", "run", "build.go", "web-build"

    ldflags = ["-X main.version=#{version}",
               "-X main.gitCommit=#{Utils.git_head}",
               "-X main.buildTime=#{time.iso8601}"].join(" ")

    tags = "embedded exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags),
           "-tags", tags, "-v", "./cmd/octant"
  end

  test do
    fork do
      exec bin/"octant", "--kubeconfig", testpath/"config", "--disable-open-browser"
    end
    sleep 5

    output = shell_output("curl -s http://localhost:7777")
    assert_match "<title>Octant</title>", output, "Octant did not start"
    assert_match version.to_s, shell_output("#{bin}/octant version")
  end
end
