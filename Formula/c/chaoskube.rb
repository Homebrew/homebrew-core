class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "6d40cd2bb9d0eee1b3637f14c9642009a4917e2c73177b4584de6bd0d8632391"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9de445ad8f4e772de9d52bce0cb90fc495555ebc63cf97054a03f2cd6f45d712"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aefaadbcfe49da56f8eb31d9d28954fcd79fc17f5e3ca84f46c87be401cc01fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1898ef8bd07023b59fee75b43db9d3fafab8ff72e36429b6c49f562f1ac4328b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33200291a34be6dbd43eecb619ac3be2d5c4f8eab0749c91c909939c4b1ce130"
    sha256 cellar: :any_skip_relocation, sonoma:         "534a605e30e270bd7144cb1772d92baa7e3e0a38900f858e3f4c5889870ec652"
    sha256 cellar: :any_skip_relocation, ventura:        "4f5c3cad3bb6f23a1225d75db028e90fde98b583bceac54b4718c4c296bd0401"
    sha256 cellar: :any_skip_relocation, monterey:       "d0cd1e28af710f912b0546638c194fc3a728f5137144e87f61cdddc3686c4cd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "36aca039fce802e95e52179ab3f549764dc42ed76492d6d79b007704aa33bd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390e9478d4a4e406af3d63d2c6d57bb09e2044b538726270bbb6f0001a675486"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
