require "language/node"

class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.25.0",
      revision: "223e262201da0eefb320c98756cc84c4bb1a2622"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c315b0dcac4427e66c7bc549cc939da012f56320aab49168cbc908d53c7448db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d2f860cac011e3cc60ba19a93ceb63d5b39a54bc1da6d72eebb59dda43e72c6"
    sha256 cellar: :any_skip_relocation, monterey:       "5d36f441c13ef43199641c5f110fc64624e4589c2aba06bca6828c70bf9cb3fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b5f5e2e9a578ddb58a9b1a16807f1b306e907a96da7c179c36466b758664b60"
    sha256 cellar: :any_skip_relocation, catalina:       "49007c39c5abc5d535b282c01eaae5f3df2bdcc03a97cc0aa31c4568b054c266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb38acc83abec8621a24b16dcf699099b8c5625e89fb217229a2b3adff1a5b51"
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
