class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.14.tar.gz"
  sha256 "bde40571c9c7a658192e03cf16a73a6899a2d713ae62a53281260c5b4f8b027b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "640cfb84917837c66bdea4f3b5a42e4c37b08f4f1e54b35a257b9a2970ef42d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9371e17643ab4143dc2d5854f4c4507dfbdc1f75e882183b6df3fd316b02d3d"
    sha256 cellar: :any_skip_relocation, catalina:      "ee554382f2b98c5324094918d8de7c1ae9a12b8058ec5c09433fb458d550ef39"
    sha256 cellar: :any_skip_relocation, mojave:        "936cb2bcc84f3f6b9bfe209980d9bbddd9bf866bab5e3d4982c258a02c9ac255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75dbc3c0e880c26ca6d66933895251add2945c669c5fc9427961cb79861ebd62"
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
