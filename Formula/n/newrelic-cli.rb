class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "5455ba86d17056e75c3cd3f5e58e3baa75317143988bfba4f2910f5e26610262"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2703db5ba71c9d973abcf9b1a3973201fb419d9e81bdc6bfd2c5366da62f16fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf270cdfaa31c704686cc452d9205eb694cfe858251dd0df62db6fdb8df6c1bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a38f7975847d134bea408b6d21dbba35743f0e33975d0e0f3010dfed0272636"
    sha256 cellar: :any_skip_relocation, sonoma:         "904ed7df7418c892158d5b604c57b9494c318d22bbffe9a96b738f503178e46f"
    sha256 cellar: :any_skip_relocation, ventura:        "e11859392ab82f5c00785b01be9179d941b6a8768809c1eec3a153a9b0d0f171"
    sha256 cellar: :any_skip_relocation, monterey:       "9b9f0189b9b9f39ef098aeca4dd60f73dea507fb8dd197c9c93b95b31c340ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68d379ff2bb7bfc282d66c8a97b6a336bfb5ae7d763c42457c481b58c4ac37c0"
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
