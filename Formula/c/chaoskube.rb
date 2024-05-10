class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "b1207b8709bec517ce594a3d768f19b43ed25a94190454f21138447c97858e4a"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bc24e553109009c7ced2ba040d6e5f00a9b71935c797fe2420b3f8ef6bf8fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16691dece65f655514f63ac8b18e781a29b4d810725a15a7d388cb61d89680ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bd9f0475c31eb0df2b74a4e7bde78d9250ca8fc7de8500e71bc75dc68380c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "0adf65b451ddafc98b3c2c922f17be2cde337ae727cd629c2fef46b0dcade854"
    sha256 cellar: :any_skip_relocation, ventura:        "fbc8526a5d413b4db5e63cf1259470670f9d0d3464c1eca836f3ef8eb468f985"
    sha256 cellar: :any_skip_relocation, monterey:       "dd253e5accc8bedba04b8612ddcc40dee7726c7baa848b054eb080aa512bb08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4088ec73228f607118272330da7f95b775be7d4f259b83c4ed067825c87e463"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
