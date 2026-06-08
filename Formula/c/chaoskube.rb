class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "70260e47101cf0735c6190fafb5ab273e5003803d332496063398fe9b18c1368"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af36cfee8470cccea2ff87d988b193d405d919a095d2574dd00ecc21777a3470"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53f873490606592e25c777af1e8455f4f7c8d8fbb1d10823e0df1c1efe00392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc69f688eae0532f1703589becb4e0a23d00842cbb10c299a14d1218da2ebd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9e9e8e0a567f9a7b64175df9e9f4b06aa04f5e18d9e364c9a86d8f8177516a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2be24dc46dededf66b285164ba4fbafb6db215a3a6e63fdd8372fea321d9a5a0"
    sha256 cellar: :any,                 x86_64_linux:  "1af8fceea9882aaee2f2db19eac55792f56e7899a854b211a16928c1de9e4b79"
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
