class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.16.tar.gz"
  sha256 "3b5547d499bf1343da1a7213f08b09518855ce48730f7f21056d5fc88ac43555"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4101f12af0c7f282b27efd15c2fc48024def8e3734c45e37dfeea0a8c3e304d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "23d1b01919f5ec444b9d7698c594cbfb927c0ee554e4c9b3e7803b8fe634b681"
    sha256 cellar: :any_skip_relocation, catalina:      "c8c71f97dbe65fbebbf4680cdc808104c7a5ba5c9c70503334481d3d2b07144f"
    sha256 cellar: :any_skip_relocation, mojave:        "2cb1d5a68e5f97b8c816de157b427537674779d2fb16abcb620c8c73e6b1300b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14578f9b455a63f99ae0f050c6f7f15247d2bffb10b9fce33c142cd01260c1b6"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
