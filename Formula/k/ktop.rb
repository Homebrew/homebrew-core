class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "130b45bc2ee4faa8051a9139881e11fc6275269df8357300ea37ea8b5f96e64c"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9304c69fd690ca621517be30a44c02a09b751f1a37548fcc71efc3e2c090bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "854dc201925bbb0c45e8b7c1a27a300f363e6c8f98b2a6146a4633852eea70bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f1f6ea705c0e224f579de2942b1357175d968068ac957ed3a0d834ba8322ba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "555129b8c4e47a3d0970565e549a45e6b7d89538d0627447e1677ef9a24529e4"
    sha256 cellar: :any_skip_relocation, ventura:       "f789416596ffa2aad19c396c10272e8ea3baa235170624caed537af6b05e7f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfdbcdfe0eaf7686d1c3fc44f06d71b560c8373223efca80645c41f720f405de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd56b99d45d6be35775b409b463ba47df2eac8ca4499e83902d0fed78179457"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
