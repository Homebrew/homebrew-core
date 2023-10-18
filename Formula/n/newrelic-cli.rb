class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.5.tar.gz"
  sha256 "176c10c2539d668dff1d134587e479ac1adac042e16dcb3f936949995d1c10f6"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a320fbdb8d458b91fe76769bb0260788faf5c9f5126b48fe6be9fe33f5e9e35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c056cc8c089b1ec64958206841ff9ae1fd254c27fe06d85f6653caee4309c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2f6dfbd8d80bf7e17446bc8bcbaefb9377709d6505daa0e7a06b6cdb43bff8"
    sha256 cellar: :any_skip_relocation, sonoma:         "27a384a65dd16c36c456e23cc2093155babee4a50c75f07ffd4e2ee92b810771"
    sha256 cellar: :any_skip_relocation, ventura:        "61790e7f1aa397dc70100ce08c6478d7886e80b605e9a0e808cc0b6fb2881324"
    sha256 cellar: :any_skip_relocation, monterey:       "d273eca31dab0a4bd21c676a085c13b5c6d43cae9168b51ea3e4ca9a2c8aa311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f1e9db27dc03d0c3f1ec49f395c4101f9cf27cc9fc03b0f596fb0b9ec305da"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
