class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.7.tar.gz"
  sha256 "733d0cf7908a76f4c7c52265a30ff1fe786d2a0d5b205771098aff7149885126"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e600081ac1af0d365c60ef7d09d8ecb56c2bc6380cbfa1b65096f49efccf1d48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb401addfec6fd162081e7faf1ec4b569dad5d25e1db7068c79f49d92ccb99f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c29fe61f80f1f7ddb08f7f8652f341dbb4c9e69b23e74fd7e32fbeabb6dcb88c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e75093d0556dd840ca5f8d675c0104a1028bf404693b348c4955249e6fc0672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e0780d20cc667601573a4b9eb8b8a4cfb4b9bc16e3d050704beaee98da9c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb352423d1de03797332173668d4889a9e947f5e82be473a72dcaebe8b0b17bf"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
