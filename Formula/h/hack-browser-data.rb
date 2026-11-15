class HackBrowserData < Formula
  desc "Command-line tool for decrypting and exporting browser data"
  homepage "https://github.com/moonD4rk/HackBrowserData"
  url "https://github.com/moonD4rk/HackBrowserData/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "539b7c36be4bd8f6fa567f10cb1c49fdb5a908b947b74a35bad900e3acf4f747"
  license "MIT"
  head "https://github.com/moonD4rk/HackBrowserData.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "229776c7a4fad9712f7a1210e82caa1f98fed9ca4b8c20e1ea0d25bbbde9e253"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "229776c7a4fad9712f7a1210e82caa1f98fed9ca4b8c20e1ea0d25bbbde9e253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "229776c7a4fad9712f7a1210e82caa1f98fed9ca4b8c20e1ea0d25bbbde9e253"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33c56b005437537fd7a8131113bd198bdcd95126ae65fc728b2f93fbe8b3ee19"
    sha256 cellar: :any,                 x86_64_linux:      "a8314cdd5871ad780171208c00c139e0c34f1878ba4b4a20915afba114601af7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hack-browser-data"

    generate_completions_from_executable(bin/"hack-browser-data", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hack-browser-data version")

    output = shell_output("#{bin}/hack-browser-data -b chrome -f json --dir #{testpath}/results 2>&1")
    assert_match "[WRN] no browsers found\n", output
  end
end
