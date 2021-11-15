class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.37.13.tar.gz"
  sha256 "f897ed37ea32998d2fba603903311d0caa76fc835bef62739ab122863fb28dfd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6be6cbd8545b3733680445d5d6e38f5d1c4a2462a1b189198396f3035f12719"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ba9235f2a9f535267561133aa46684422df1003b30f4b74cde4d85ebccd6de5"
    sha256 cellar: :any_skip_relocation, monterey:       "e4bd341050025ee913b486df15d92b4c7312d8ff779f69162e14c4d6082bf9b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "39bdf5e4441d5dff62169a79f9f3d74a5ec6ce9fdfef368a294590ca510e62a9"
    sha256 cellar: :any_skip_relocation, catalina:       "10782c1f841381549e99e7654bfb623429bef7c554258c637cf472dcd1de4d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3ed988f08f9a0625abfb38ad89418c9f9a58f5011b979ed7405fb331f864cf"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

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
