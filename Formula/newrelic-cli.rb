class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.6.tar.gz"
  sha256 "90c1f3ebcce6ba960694105558dfba65e7c39171d698b55cacfd0666a03cdfcf"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28f1af4ddba962febffa121f8255928a6e5ead8824e1c9eeac68fb62b7fc7b8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6352798c874af8c0034514af7f9bb243abebce7d6c2ef13d2e476a806ff23431"
    sha256 cellar: :any_skip_relocation, monterey:       "2a970d94aa9c2b69310c4b81720250dfb3c0c7ca6018efcff9b822f437285192"
    sha256 cellar: :any_skip_relocation, big_sur:        "599245c9dd4adacfd55ffb7852ba9b9e03b6b4c272ba22a286fe06473a927131"
    sha256 cellar: :any_skip_relocation, catalina:       "b887b96ab52839540fbb387a98d0b12671e97ce01f69382c18fe9b8414dbc7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd85488c44a14837b931f1c4a1c515f2ed952825ee349ed4fac7e3d163f7470"
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
