class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://github.com/git-pkgs/proxy/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "9a66aacec64f02f850cf2f3106787045750f8556bdfac32442f44ff8ac781780"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a25616245c80eae43935db9b41c3cf8203720e4c08ca3fb0d06891f32d4f10ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58b7556473de82b4389c0cb3a01ae5ce5e31e3cb7ab7f03a47478188995349b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f9a5c8ff8ac40f47ba0821bf52958237f1192bf7f5040a9d2d0379aebc69b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de2c64bb91378593710bd9aa43bd9e45d9403f6c0351093d6057c01a9233b3e9"
    sha256 cellar: :any,                 x86_64_linux:      "f9a949578ee6c78321ca2a44092941b440db9e58fb9b775f3075564060a13a58"
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
