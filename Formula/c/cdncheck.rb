class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fef8644c0efd215feb28738d48e4e07ad106c9159ac08fe167a46a7b32f07ce9"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c7460bfe832254b41cf180b7767fabc2c3d52b23aad990783143e6cb730bfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ad11fbaeba40508ca2ceae361156d2d66963355f1aa05b2f28c26a0747bd2a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bf6c89272f824b48034fe9331d16f62c1ecb0be866a3c88fc0d1fc420145f6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d442205b07302b60d25a468390c45c4060a27c248aada6d2944381ce1c6560e"
    sha256 cellar: :any_skip_relocation, ventura:       "5e385b8e9e1f9499eff500c55afdb4df15e3d4a8ab5540d0c6fe9615fa854d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d191d7f40f2bd2cfae453a35c1dd42be2d8e9accf1475741350816e3206410e0"
  end

  depends_on "go" => :build

  # Fixes incorrect version
  # Upstream PR ref: https://github.com/projectdiscovery/cdncheck/pull/379
  patch do
    url "https://github.com/projectdiscovery/cdncheck/commit/d85cbad8c8afccd534cff23481a8e22cc5b1f7df.patch?full_index=1"
    sha256 "aa4fd9b6b5307cf3ac68f4e8b7f4029b0666aaa1a85f15d8f51cc8de19ea9450"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 103.244.50.0/32 2>&1")
  end
end
