class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "23000183a33e10bc39edc69515a92a1331ff8486a306814686336be7c10f33fc"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d404389a447a45098d2f299a545ae890a1cdd77c91ed5b55861049b9dc505bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "519ad2e84a0a72ee268170e9ec0752f6a761066b716eaa8143e23767424cbf1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c00ec01eb256634fe6e10cfd6e9d303871060208adf01f8c17ccb7acfedaa77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "567d4ae913059c5244e5bce3460c648ffe17011302214be84af999525e576f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23eb82bb4a90ee62857f338fd688462f9c56a4242af2779d9c59fb404f819ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89bb317cd550675bf0151057430f10593963f428c0d210db21ce7c6f83b4a88e"
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
