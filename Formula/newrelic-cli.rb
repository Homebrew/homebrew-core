class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.32.tar.gz"
  sha256 "932b34b6e3dc4c0dace403db6c267b8822bfe8ec9cf25eea4c67c4e2b49932f4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "720442de58268bcfe5cda146448fced026aa11dbc3394f0ba4d6a702611cf52f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6d5c1d3ade65f2d113b81f3c76753edc88c908fde8aac24d8bc76959b89c6e4"
    sha256 cellar: :any_skip_relocation, catalina:      "1399adef6bdb7ef18091bf9d1b780b049ab5503c7c2907c060aec9ee2952e94c"
    sha256 cellar: :any_skip_relocation, mojave:        "14dad21712762647b16c8e0c9a2fb0dbbcf1e30a9f5f5904f075d238851ff329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c9f9fc5775a9e7aefa5301740961123a4ea7aaebfd7a4d32f290c583bbe687"
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
