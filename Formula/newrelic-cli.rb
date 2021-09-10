class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.35.tar.gz"
  sha256 "16fb2ab299d3827fa829c298b532a401405ea3995bccc5b155a3ba002f476633"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "646aaab6133f2fdda26a7af1c366aac13dc1662eaaea4c072fbcd3d930876e02"
    sha256 cellar: :any_skip_relocation, big_sur:       "93773341a651b93fccf1fbb743a560d9ff216f99f8603c66c250e2711da9ffe3"
    sha256 cellar: :any_skip_relocation, catalina:      "2694f6e8a260be4850e21db6e6cf57317ef5afbf7abbdb510d6e872d49d0252a"
    sha256 cellar: :any_skip_relocation, mojave:        "47bef396643fcae498c4d677a0fdfbf525f46aded2c9c3b011bc6f9ead0948df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a9de1b93429baa9986363d92d0b4e6f5e1256375d9d150e084bcf91e4a742c"
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
