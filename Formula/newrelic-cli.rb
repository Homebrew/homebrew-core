class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.7.tar.gz"
  sha256 "684d788a2efad8f1218aaf780df0ea45d59b90eaffd6e351ce3e44d0c06c1453"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e85a8fed84d3be4a09bbd2be0ec99ce74a1f26759b51ded4c358f8a11eb5657"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eae6c426ead8203431f85e0dedfa1066deedbe760c8ca786148b13f22a82b79"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1926593d615343c6e2430db47859f70a6333c8396a069c36cd8f3e50244596"
    sha256 cellar: :any_skip_relocation, big_sur:        "185d5606b6bc40516290bfae25d2cf8877a818cdb3aaa422933bf88ab1a27b65"
    sha256 cellar: :any_skip_relocation, catalina:       "89f0c038d5ac3b1222600de85a30481395ed2fda355ef66edcdef225d6fe7247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c22339e023f8d838f719294448c8898c46cfce537e0e0409d7ac8a3723b513"
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
