class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "387588e6eb8927920e45acd4121c90756ad69c6d16f5b7f94f2ceaaac45d3a73"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7ed7960d0d3d8dd9a783992c72819879849d14f7963d358ab92031c2b5408f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b39d47afd0dc7fdbfce9f558a171cac85a220a09a1c51c515a1e05666a6812a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442689f9dbdcc2f0a04e1992bff5b73bbf9580e1ba4572c3f12c916635e798d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fc4f61150122d189a1f7527b696d8e869c3fbba7d3ffcd17a29ef2623d881d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6283e6c1230425687d0190010e2e1d884895f551e53dd63ad7ee2a8482bcbf7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a81dac9befc95952641f2018ac92eee92a4e53da0b79fba90e6c2cfef8b51141"
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

    generate_completions_from_executable(bin/"falcoctl", shell_parameter_format: :cobra)
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end
