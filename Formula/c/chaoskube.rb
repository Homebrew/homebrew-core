class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "37bd5a84c17aad1811aa7e13e22082057890bf37ab0f8d470aef34124e8bcde9"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdf989f374a4780afc93942b7a3a356a8e2f2d5a05144b6b465e39439732303c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b02858cc283d0d783d1bbf9ecf94265258031ee99c97ad7483767175c4ac8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9e3f8158fb25a5a3e132d3b4c8704ed23f391f0dc6e112db47cbb9a4a59302"
    sha256 cellar: :any_skip_relocation, sonoma:        "93977f5b38b118748c84a4cb9e71c011d568a1fe85cd236fa00e9327da0a4543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed66fc035e1ab053487dafe2cba3ccb035a0100df60cc307fd10bf7d00a0d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d25d870f6667bccb35f16cbb59701a4262c90d1a6091e50a7701159dcb161f"
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
