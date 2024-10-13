class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.24.tar.gz"
  sha256 "bacbe2877d03ee627c2dc2011c4dcccdb82d19637c995091cb7216295d020a4a"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "70d6d590e0d97e2e05c125d29e03ed4703e7c9cd9acd7e3a83122ab4abd90940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86a07a6f8c009cd3adec7d5a7639bb9393c48f90682c96e7f7cab1a5b7cd75c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1964f32ec897e04308b142c2ea5cb9213abaf416ade72ad4e9870de42553f81e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c628f325ab4c0d263b01d5e8e3f3d806793ec36df038cbca816890c7a9d2df2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5339c7f6e695d4bd8d7a6de946cc3453c88071f4e2e4058fca5b32e0f685e9d1"
    sha256 cellar: :any_skip_relocation, ventura:        "4944ffaeb01adf61da90e9c320f2a9f2a5412392e807cd006546edbae1c19c22"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb7643e16a15c1979649c5d42314a1a391661149568b1297192aa0b2d6450f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703a2da467cd05ac8036c30611dce4add4c5c297d9285fefab1ee24efd1d56e3"
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
