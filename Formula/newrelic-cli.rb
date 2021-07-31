class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.32.1.tar.gz"
  sha256 "4e9c4fda4aec0b5ab677724b3052e982dee1d0923a7719d2f105bc0b7f9a19f7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d1792c8ab67be8a31301f850602942b8bbfa4bdfa3166aa643b03c0a91f6811"
    sha256 cellar: :any_skip_relocation, big_sur:       "1691d025df00fc9f91390ad4b95f6559951b9020d71c1a010f1d6bbb8b448beb"
    sha256 cellar: :any_skip_relocation, catalina:      "c47d0ee41181b9b49fdefc14fdfeda7ce67e2fffd84359f4d0ebbb578d0b6ded"
    sha256 cellar: :any_skip_relocation, mojave:        "4c866aee2f0cc14441be8d6278457f2bb6b47ee36dc320f087cb3e8dc41bcc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412566bba758a86646128df9e2b3e76cd6958f59c1d4d9edb71a02f61766d953"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
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
