class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.23.tar.gz"
  sha256 "605e5ad01eb74cfcb369df73a3c07742b05d8fb9db84c172ac45c5fc514f4194"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eb1f4e78b2db719fcfeac517a801f7af02329391d7b54faf4797c1417c5e771"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a387849b12405d6f3cece731a9adde8cade791a229c96e03e904f34adc870883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ebb265145489fceab8cc3fb8952fb16331f23966b7e775eea7fe70ce1fb3d7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9d844ef73646dbba5ffb8b3e3b0948b29f76e54be0c9b89454e83832ee0c10f"
    sha256 cellar: :any_skip_relocation, ventura:        "9789e7e84d9082e5673398befb809a0b2a0e671daba981bae3da2de54a016773"
    sha256 cellar: :any_skip_relocation, monterey:       "a23661d02af1a98b9d0840c449ce22ec11c2cc7771c2e7c273355ad328d9a7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ece461f3aa48dfa7798a8a0878eb50ae284fafa31cacfdd42af653e76862c91"
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
