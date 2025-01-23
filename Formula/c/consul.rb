class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  # NOTE: Do not bump to 1.17.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/consul/pull/18443
  # https://github.com/hashicorp/consul/pull/18479
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "0dacc7eeacd19a687e20fa83ae88444d2a5336a9150cfc116d39a39b31d5829d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5ecfde4c3c53d2ecacc3eb9f95b6445943751af420f27bb7aa1fbee5d85d1fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6784612460c0d45dd1ebeb8c579100dcdb9daadc498c61474aebc98d3fa4b660"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a67ab933f39fe146541aed6e6c578e1064afb7311c63eba85664693ca97ccef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2238d0e5d5a02af34d0a9e53f6f8f455b7778ce22167eb1e32accdbb220d62a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddb3d05f6604605d07ce61cc388b484c9a0754f543611cf430494450aa153046"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e684452d9f672db363b69f03a97dba160c6b55aea327e4bc417e1c92cd2ff64"
    sha256 cellar: :any_skip_relocation, ventura:        "eab2edbb1c4820c4a9d83231edd9ec56872cba032b69ba7218008a198d8376bd"
    sha256 cellar: :any_skip_relocation, monterey:       "6987639e933ddb0d09fc539fdcb71396d6797dc4ca54057d9fe14ce8828a6099"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c0fafe916d70a9ceb15d92bdb9f44fd50352eb78d6790cd69ba0dde49a99a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d8f2e7148d80ec16fdc26b3a75e4c46f2f1d5227944f5c79de76d6a21b8d97"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  deprecate! date: "2024-02-15", because: "will change its license to BUSL on the next release"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"consul", "agent", "-dev", "-bind", "127.0.0.1"]
    keep_alive true
    error_log_path var/"log/consul.log"
    log_path var/"log/consul.log"
    working_dir var
  end

  def caveats
    <<~EOS
      We will not accept any new Consul releases in homebrew/core (with the BUSL license).
      The next release will change to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
  end

  test do
    http_port = free_port
    fork do
      # most ports must be free, but are irrelevant to this test
      system(
        bin/"consul",
        "agent",
        "-dev",
        "-bind", "127.0.0.1",
        "-dns-port", "-1",
        "-grpc-port", "-1",
        "-http-port", http_port,
        "-serf-lan-port", free_port,
        "-serf-wan-port", free_port,
        "-server-port", free_port
      )
    end

    # wait for startup
    sleep 3

    k = "brew-formula-test"
    v = "value"
    system bin/"consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output(bin/"consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp

    system bin/"consul", "leave", "-http-addr", "127.0.0.1:#{http_port}"
  end
end
