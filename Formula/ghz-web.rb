class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.108.0.tar.gz"
  sha256 "fd3f4f451ead288622ebf122bb52edf18828a34357489edc8446c64b0cc10770"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd2e8196d8e9f69811439fffa8e04c5e17a0ab6aed527c78b62e57a0d74ca754"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7684013b41101cffff1f49b9953bc2a2ff98bfb3ef1b4612227dd2aa1448f443"
    sha256 cellar: :any_skip_relocation, monterey:       "65be6d04437d6a602128e6c625fa98a517e515fe5db78b9746cc2e0bd320aa7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1214f08a996d4fb4091d0253ea853dcb784ca0dec1470e77a4e66024c7ac61b4"
    sha256 cellar: :any_skip_relocation, catalina:       "291832ffebc6d598950c60aec32fb142bc8855674b33aa452bf4b2f69bf327c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f203fec32c711c8c946d2e9502b2a049a8920e8db5a7591bebbfd752a48459b"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
