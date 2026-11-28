class Fluxcd < Formula
  desc "Open and extensible continuous delivery solution for Kubernetes"
  homepage "https://fluxcd.io"
  url "https://github.com/fluxcd/flux2/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "c51e8faaaa57ecb517a8956800973ea39fd30b7a003a6eb3d25f88595ae1a093"
  license "Apache-2.0"
  head "https://github.com/fluxcd/flux2.git", branch: "main"

  bottle do
    manifest_sha256 "3301a9de6779b029efa4a3a96dc95e704996b0520d2bbe6e5a02bb93f4fb063d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce5dd3590102cf588f927c22257cd0066271267a7af7cee0206e8628727f2711"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13cca67741c8d0db250f06f6ed552f80f889afa05830dc92935d2808359e41a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a24ffd8e8825e7ee16aacb216ac63147c97fa51574108fa846fb4df81f05d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7384a08a7ae42dc8dfeff316da1177aaced825f02c02ea65debef6511bf037d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d94482bb65e53e2257026b3a525a58dc4bb4c4cc3591287f441cdb109bfe27a5"
  end

  depends_on "go" => :build
  depends_on "kustomize" => :build

  conflicts_with "fantom", because: "both install `flux` binaries"
  conflicts_with "flux", because: "both install `flux` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "make", "cmd/flux/.manifests.done"
  end

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/flux"
    generate_completions_from_executable(bin/"flux", "completion")
  end

  test do
    assert_match "connection refused",
      shell_output("#{bin}/flux reconcile source git test 2>&1", 1)
  end
end
