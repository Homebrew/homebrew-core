class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.42.0.tar.gz"
  sha256 "da5c6675b4690bc8718ab38bf060e2583f309d1a2e4381f11615346fe4f26a1c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5d5f8891ccc8605ab5d8df3bed173c12c380978de845e5f73e39b4d386b420"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72d49750a8467710ee89184230aa3009a421579e4bc537a6cd09860715a75cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "484368afaf5dc719ffddd958bc9dacef20ac19950e4ab65a440f3b48b458b54e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef4fe48dbe7a2ea7de16cceb04f8eef937cef663042eadd285123efdde455591"
    sha256 cellar: :any_skip_relocation, catalina:       "67bbbf983aec0445303a9be8eaebf619237667ff5e530687f2cfceee9b7cc321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1658c3eecfbc7948092c76b255b5eae7cc059dab31385d316e94d197351d5736"
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
