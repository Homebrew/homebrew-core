class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.5.1",
      revision: "e546fae8cbfe95d8f36a351deb2cd23bfb94119e"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c66110fc1d55c746b8db1272480d475eeac366492f395142b1eecd8da16e5788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f86fd27349fd698785e7a4b305979a854f14d2d6e96451cc2410be2942922be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16fec8bee40895262acd846f24db37c1041473b94489af380e0a06da3abcc09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15cb0f80cc9b71ef4e39831636dfd99079243fcb7a2f46b079526bf6e61c6ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f06130fcec49aa617f57c82f4b4f285ada70d7b78d888e55d652bb9162803d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d9baa37cec585e22ce775990a3dc2f2533d7bed313d472cbc642da498c3414"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", Formula["node@22"].opt_libexec/"bin" # for npm
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    # Bootstrap go modules
    system "go", "generate", "-tags", "tools", "tools/tools.go"

    ldflags = %W[
      -s -w
      -X github.com/openbao/openbao/version.fullVersion=#{version}
      -X github.com/openbao/openbao/version.GitCommit=#{Utils.git_head}
      -X github.com/openbao/openbao/version.BuildDate=#{time.iso8601}
    ]
    tags = %w[testonly ui]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"bao")
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"

    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end
