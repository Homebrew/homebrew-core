class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.15.tar.gz"
  sha256 "1b67c0b8b9f9957fda74ab4ccbad88db0cd6cddba0a7c226ae271a2e5a4c30d8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0a667dc004b342d018ced9636337c9ba3263ca2d256a33d34de12a802ffdfe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "532c2b101f0768d98a88c4c51f070db12b33822e6fd678dddeb2dd17402f65e6"
    sha256 cellar: :any_skip_relocation, monterey:       "4342d2152c70dd51399cf25ec6b6d3d228fd2a096ebe16dc2e31be8928d7cba4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac127ac6e490e5a7c3a58a43e868b01bc4336b65f153c037b4124aecc72eeadb"
    sha256 cellar: :any_skip_relocation, catalina:       "c234bc175fdf4953d789669f2d704711cf5656d4e7db4ba397a12730994c0e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2400a976924b13265b6f5b44a68790892d3533b1d7f113d05c2d3d25933a97af"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
