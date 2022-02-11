class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.21.tar.gz"
  sha256 "39ba575a6541bcb2a1ff5c66426f46091c33fc006202226294237ec4aab4178b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce3d8446c883117ef5c3a8827794056fd55d215524d1c3266a7eedfcc4f1d25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f83f16ab94c02a995c9977ee80dfba4ff589e2a02b1b39b9a63706617c66ea95"
    sha256 cellar: :any_skip_relocation, monterey:       "fa094cb4a3a9b0e04f4228b5ec89893c3860930bef3d130a91e0b0144fc9e86d"
    sha256 cellar: :any_skip_relocation, big_sur:        "59c736df1bf19359abed3292b706d4043deb915cdb7681a3280216860374f1a7"
    sha256 cellar: :any_skip_relocation, catalina:       "22bdb4bfe123f65cf48a5472d7844459c2aa339cdd2b93b086d34db478413ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45f23f476148d40212cb27278215b8f73a65cef88d83935ed99fe7b1add631b"
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
