class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.2.tar.gz"
  sha256 "0dd198c27b156c65a55c175ecbf3749de237aa9ffc32752128cb00e54dbe2b95"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7d72c6bbd87110086242b8436b394224a6dd0ca93cf5a4f6079b76edea31d24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "948ea5e951bd952aef05b9d7326ef7208aa5e9adb2137e71bd45bbd92550f99e"
    sha256 cellar: :any_skip_relocation, monterey:       "d23ac0cf2715ae4d3849e0099947e6c81a588aa19d0d345763be49a94033707d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e8ba12eacabd41595244fb9e32d3a8e53feba6e2657f39ae8ba608f00201b3f"
    sha256 cellar: :any_skip_relocation, catalina:       "21c0fad38db62e954f3f0f991b0a1e58ea64a122c97652341f0b64ee7806f329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b4ebd501f25db9fd83683529a8b40f7fe550449987ebaf781d459ac08fcbd9"
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
