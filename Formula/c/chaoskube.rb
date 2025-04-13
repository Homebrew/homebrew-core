class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "2eae4805598b3d609e784c2ac47c979a0fe6aec65357864c972d1108f593ce8c"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018fecf373d6ba10b17373a34ea77b9ad16a13af6f34cdafd02302fe52fa53b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "018fecf373d6ba10b17373a34ea77b9ad16a13af6f34cdafd02302fe52fa53b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "018fecf373d6ba10b17373a34ea77b9ad16a13af6f34cdafd02302fe52fa53b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e86199b92d40e53fb6ba0595832fff63f65aae534d2cdf7dea71355cb6ef44a"
    sha256 cellar: :any_skip_relocation, ventura:       "6e86199b92d40e53fb6ba0595832fff63f65aae534d2cdf7dea71355cb6ef44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b88ac5ff4840ea5bdfb00fae4f5e989779126ab05e84ee37fc9fa22fa6ba984"
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
