class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "de4d677f2c3c718577124c3f6670bf209789b6be657138beb71a1fd1b991fced"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "309e2d8749d30325c0e508ddf3cbb00343e30aa4b2d5090efdbf3fd5b8d5b95d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca936cc535d201aba1636bf6cd788f02aba20cee10d703aa0fbc3227f3459c80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5974a6e8caf3160f6f886baea38518b0961259772c65fdb0f4c04f535744dd87"
    sha256 cellar: :any_skip_relocation, sonoma:        "66b729058448bce9feb3c424c71e9ef54bed67da2ca4a759936a81c6f928d4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02956f488437ab657367f5856257ea8d5e63855a21816184871e3bbef8fcc5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a27d7241a1a6b683b59feaa7593d9c8de5bd3d0d5767c6f9fd29c40f3cfe905"
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

    generate_completions_from_executable(sbin/"blocky", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
