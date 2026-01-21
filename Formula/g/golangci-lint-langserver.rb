class GolangciLintLangserver < Formula
  desc "Language server for `golangci-lint`"
  homepage "https://github.com/nametake/golangci-lint-langserver"
  url "https://github.com/nametake/golangci-lint-langserver/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "d9f1fc02861eeb9ce60c89e79be706d7ec636f653d5039a76857b18cb98875fb"
  license "MIT"
  head "https://github.com/nametake/golangci-lint-langserver.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee344feade405e6d22efc52ad554507a75d4a8931ab65bcdae601d693f51a2f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5eafe079a2d42f9cd35c722bb93765f700b9c547595897a8f6b97c9905ff2a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5eafe079a2d42f9cd35c722bb93765f700b9c547595897a8f6b97c9905ff2a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5eafe079a2d42f9cd35c722bb93765f700b9c547595897a8f6b97c9905ff2a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "637f71edaf16e568757acfa3f6e26b955dcf1a93d5e1a65cff8a0cfda928159a"
    sha256 cellar: :any_skip_relocation, ventura:       "637f71edaf16e568757acfa3f6e26b955dcf1a93d5e1a65cff8a0cfda928159a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bbfedffa0e82cbc9b4a8aaaaec98236e47e044089f8344760350a099b2b18fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "964fedb6d96cd53e6a2c708438015db9a3a47fed07da23be7e4998f29e5acbc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"golangci-lint-langserver", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
