class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.3.tar.gz"
  sha256 "faf52bfcce034cdd49881b3296872eb3e262a4f32685cc042f074b3adce4b094"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f2289ebc38b9dc8928c61962d7d27337bfe4c281ea4dd086c8243345260ade"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c46b1e74accb714219ddb389af91285c802d9810a47ae33cd5f3904f59a83c6"
    sha256 cellar: :any_skip_relocation, monterey:       "d1a9d6e4b46e32c05d2d81df963c32335b10072d18f9e6d9ad62cc16b4151f9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "83ed65bde6ef8f4c3fbe5bc6f410c490ea6271a00220f695a7c6a1410b4d8a4e"
    sha256 cellar: :any_skip_relocation, catalina:       "3c732dbc03897c48cfab96dc9b23bd44ea745e9ea88e98be6311343487befdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b983b68e9f69ba0aabd79bcbb3c23172f55c76af0d8b40fbd5e330bf23c5d6a0"
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
