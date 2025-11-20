class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "de4d677f2c3c718577124c3f6670bf209789b6be657138beb71a1fd1b991fced"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836ba7fd58ba09685423a55e135597fab2af6410609d5ef0123de5c268e549a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c70bee57d855a00ebe0497f50a0d7cf1d2beafdf1262004b5b31ae328ba271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94654f230e6de7ca82fc6982753df957077f307363a737405d28395ba95a7e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "11942120a988e69dff004bf9a955b8d1470a8b2313e81ba3c7cc06a8fcbb577b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff040f0109853a783da43aa18c8c371b3684566eb468165be22d4dda4021d216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd076776a2a33658d4da27be7fdaab47d0bb0bc86823e7655b3a82a1678a5f8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
