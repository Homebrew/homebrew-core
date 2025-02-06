class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "1c300557fd8b29b4801d1d608267def5514634e50fde837db4634f7f3cdfd638"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ca52b4acd298d24a47d3c47a8591137d4fd0e25b4647fe5bb9cd19a75532e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4691eeefc9e5d4d3f02700ee56d84869f1bf7f0d1123761435cb54fcea305cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed62464c37b519f1930cc6411bb379d3600b23e71c6dc01733c66de0754d8be0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7da802183baaa9f442597355c092c631fe39c173e8500028430fbed0e6b2d1c"
    sha256 cellar: :any_skip_relocation, ventura:       "f07ee1c63c5adec56a8fc3fb501adca66d3f941166a7472dfe94152914122bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ecac49515b0f517114e252470a9e54dbf630681d8be0da8135707e28fadc2cb"
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
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
