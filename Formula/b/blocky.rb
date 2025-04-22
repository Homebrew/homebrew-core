class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.25.tar.gz"
  sha256 "856f09cd5df5dc20a44067113dd200a3e74465c3ded2b5dcd473188b3c764b11"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f13867d7f062db877b46e6bdba815ef8c44a813142c5f4f30adadf1e2968da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f13867d7f062db877b46e6bdba815ef8c44a813142c5f4f30adadf1e2968da8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f13867d7f062db877b46e6bdba815ef8c44a813142c5f4f30adadf1e2968da8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d909115c5c25eee7f855d5642a55dceda1812202cec3ba97fbb422b9f29af02"
    sha256 cellar: :any_skip_relocation, ventura:       "3d909115c5c25eee7f855d5642a55dceda1812202cec3ba97fbb422b9f29af02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f9546d8772ae5b23c4e3f6eb1ff39a31436c7a0995fffed893e2387312e4a5"
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
