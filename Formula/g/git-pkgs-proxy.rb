class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://github.com/git-pkgs/proxy/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "b07335586199df429dac55c0bfc2d1a3d9489ada00c8c1583817ffa491722189"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec1599a70a9419eb2e547f819ac5a51376fed27609889e1524ab071d40362e91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf04a9a496047991eff0a2d35405ebcdf633e7d0543031213d51873762487fe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a18505fb9cd8428db2051ab9bf6052b0fac8b9041666e1d1251e6e2cd0ed4b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b5948d056ff08c382ce8497a23658fffe2fff503296939827d38cda9b7b683a"
    sha256 cellar: :any,                 x86_64_linux:      "6ddd7713814bfc6f908c9f4c9e87ee6370f7f26dcad332c20e64d4bab5a77e73"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"proxy"), "./cmd/proxy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxy -version")

    output = shell_output("#{bin}/proxy stats 2>&1", 1)
    assert_match "database not found: ./cache/proxy.db", output
  end
end
