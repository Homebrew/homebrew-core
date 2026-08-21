class Fluxcd < Formula
  desc "Open and extensible continuous delivery solution for Kubernetes"
  homepage "https://fluxcd.io"
  url "https://github.com/fluxcd/flux2/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "123a43ba4dc80e338064ccf39ce8ee011fae0c3f140bde4fcd90b722e557eef2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3d80e66dba4925ffb6a4269578dcfb7fddfc3ed42b86df810838087dd157466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42893b4b594fa76a77d5f0cf42f7faa46f98ff9930aeeb67b0c123a208c5605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfb453183d080d3d8a1d7bb16043e0f4d6186b38538603645c2d54a0403400c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32db7cd930a1bd0dcf0d12cec942668d31ea0ff7093c7d1d2ac2c9bd30e4b5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cca3ce6b2cd347a31525d6f9c6f7db93c8b1ec00b18fe08a738bab83a4221f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a827f18dc48ae5665af356eaf8e65e7493bce0a06d84b209533e27394f9fd01"
  end

  depends_on "go" => :build
  depends_on "kustomize" => :build

  conflicts_with "fantom", because: "both install `flux` binaries"
  conflicts_with "flux", because: "both install `flux` binaries"

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
