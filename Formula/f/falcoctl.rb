class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "6c643293373708e6a2981cba595758965f631c103e3460a984ded3a9b81bf1db"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd5c24fc0e01586f00d46ae36ae7dc6e07442497e8677957a5512eb5ac2ed0c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5e1ba0e72c05da62e72aea9709793f3368477b4636431ad0c0c609cdc787b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68b51554f30d8fbc4fc7145d9b1a227570bad8538cbe6ebd9e6c63d9313df343"
    sha256 cellar: :any_skip_relocation, sonoma:        "019db70f9d51659accdd6b89cd24bb16f6a46fba8f29efb784cf18e5eb125338"
    sha256 cellar: :any_skip_relocation, ventura:       "1c7164696e9c2d6b48287757af8e2d293fa79f714e4cd17b120f34eee441f1a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96bb2826210ccaf926242b57d211e7cba97e9b537e1c3e9099397a4ac8ecae31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52136c4c220fe98433e660a4a5a8d67369e00d2d9663682251c8a54f7ef8c0a4"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
