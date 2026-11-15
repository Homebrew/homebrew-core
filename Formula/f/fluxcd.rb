class Fluxcd < Formula
  desc "Open and extensible continuous delivery solution for Kubernetes"
  homepage "https://fluxcd.io"
  url "https://github.com/fluxcd/flux2/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "1b96e764547d572c0c217e8a2d326370a71cce977ab597cc16894aa9cd095b87"
  license "Apache-2.0"
  head "https://github.com/fluxcd/flux2.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9a687a94258906b462924c271442f7a8c19c7e506a4f50312549ac2859a6a40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88d54faa549f30af622fca339ac52a19fc0fc79c25b7d36e28bbd676cbf71941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd521d6cddc91818d56c1ca5e442803009392c736195b48a30c5b2c9398b82b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf373507e49a25aaadd1cb0df4df78f455d2c9b503f1a31bc93293f94aeadcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f1ea521d62bac61d11b89cffb0260c9155e6defc8e2f2ef29d3b2bb048fb7c8c"
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
