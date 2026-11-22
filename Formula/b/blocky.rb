class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "1bdd2269625880233a554f4043aba6640c48683662aab62ab58d3e2ad4483eb6"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5b8e0f308ca53c3e273be2bca731f9074c4d51e5464c5bda701fa044432c57f2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3443f24e4b344f8c9b5bee340d65a96b262e5d36aaef75f4a05dd043ca4eae5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e44d1f39d7da635296aaba45093d4eb1cf2aab5298ffe25d0f4dbb315b63302f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "863cf0cbc155d7bfc5bd46de2429462556429b70b99c946ece7ba286c5cfcac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a2d455f278af8d3dc39cbb498183e6950ba404d7fafa73902adc661021e6ed9"
    sha256 cellar: :any,                 x86_64_linux:      "420672079fbfa9563f0b57231a260c6d62d9a61f0f76d0ed719afac96bdb89df"
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
