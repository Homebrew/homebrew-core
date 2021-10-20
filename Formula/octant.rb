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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e7f96d371260d16f72cf058c2971ac61e5357ab492c1782c6ff6e3db71238ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "8774288e4251c3e811e845f9c9f7ee03dfb934b87135ab15d25db20e6088d81d"
    sha256 cellar: :any_skip_relocation, catalina:      "0a7d42feb95cf0e3bf4d9ac7e99d9c8913448349253ff2a527e2ba9d7a14d7cb"
    sha256 cellar: :any_skip_relocation, mojave:        "ae125c695c751eb481adc21d1826d33056a960ea3f8e2562da1fe13e488eef29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd5863399b8bb95fe58991415cfa003e0770550e5e7a0b680c3c323e4df725a"
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
