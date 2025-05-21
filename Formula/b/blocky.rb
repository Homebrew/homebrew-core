class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "ee2ae6f520442cc6797bf5b00ebef797da3a3c1bc90eb65aae05cb00f5e4eddb"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21784f7e8744ad2c3cdcb78502c98df54f0c803de305820e11f7a319b4b9805d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e0bfb2ac47191d6102da9953af8faa259b7b71325633322c2cd8fb6382b48d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8ebffe3c41241583f0429ed98eab9f20cdd9c1d44ecf0ba33aa063f3c08f562"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3083ab297bbe2e02f7ae73f024cbe9db59d6c29bcff6a2205d030213a38c73"
    sha256 cellar: :any_skip_relocation, ventura:       "1174161bf0c8be26b8c22ca0dddbb47f57097dd375c83a45a218c78f771497f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc458bca0abb7c696bf1dfa4a53d9ef193526e98b93f1af5bb470460431de53"
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
