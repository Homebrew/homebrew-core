class Erlfmt < Formula
  desc "Automated code formatter for Erlang"
  homepage "https://github.com/WhatsApp/erlfmt"
  url "https://github.com/WhatsApp/erlfmt/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "6586ca7274a7cf0146c4942fee234bb200f8668a8a08ca2d408692303b3e0948"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7da0e6df392d0ce2489130e4caaaab3f96a00761fff3c266a04410b379c12933"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9cc7d8f48444d942668b517a7360aad62fa07b265180949e7e360c7ce7d3a33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49b72b4214ae8f085366e366789a73200d7df5b9bd58f1c21cba489dda2f3289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "874db7c6883fe3334cb64c9897e4ca42c31f1e5e8c99cd77ad0e8d20b7ed6b4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62f1f5033df9c9266f4d99d63763a2ddb0605d2e9996135e2a0d7bef8ab475e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "393cccc558b5e2ee7b3bff3af81e0c7299cf06dcb8adec4ee8d5d988efd51e35"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  deny_network_access!

  def fetch
    system "rebar3", "as", "release", "get-deps"
  end

  def install
    system "rebar3", "as", "release", "escriptize"
    bin.install "_build/release/bin/erlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erlfmt --version")
    assert_equal "f(X) -> X * 10.\n",
                 pipe_output("#{bin}/erlfmt -", "f (X)->X*10 .")
  end
end
