class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "135d9570499cef12a3d4fffe46e815a639c79d0cf39113ccec09cf3905141f17"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6dead7a4d97781c4e8d46fd95c8a1699320d63fa12f7a6b37329e1e6a4d40a82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f16d4a2d96e544c772dc7a1878d2bb69934944dffe3ff99787795287960bd75a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1b6075e1f04f2d2a4220783b479efe7f2dde732eea0e44203b9b41312c8f427"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b1237289adc260093ec68da4fc4a47fd81f6e71888de17a3afe0e51de10a71f"
    sha256 cellar: :any,                 x86_64_linux:      "0990501fe58d71762634f378ec219f5b6c35a4b8ac2bce8fc60c65e9d8c09af9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
