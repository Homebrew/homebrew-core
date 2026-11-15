class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "98b613b88c2b960b091ebfa7c3622a325e47528da6c636d313efdf183a8bd254"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2de8b86d3ac459133f8cc0384461344a5727af8df27cdd69a7e4c67b4d333f4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd83c657a779ce76e1e99f2c7bb93b19d82bef39f35f5c17b6e72ade22c2c1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c07729963d3d08bd366e70ac6be6296cb43ee59e2c8d38c43f9ee4ef7baa605"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba43e9d01a3fc29fe0c31d8e8932f0bd5022e6fe38f127aff39fcc76d0ad7483"
    sha256 cellar: :any,                 x86_64_linux:      "1639dff4b50901de5fdc8c7f5e3832a4f5a4b6a86bf0988a101bcbe8f4867d02"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"

    generate_completions_from_executable(sbin/"blocky", shell_parameter_format: :cobra)
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
