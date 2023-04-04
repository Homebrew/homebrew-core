class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.65.7.tar.gz"
  sha256 "65c0e048e391f7ec8d2da2b9269a3c7bd53530c70d5c1330f8953b6637d56228"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31bab29f5a6512a5788366a76571b2e47e85585b5553ed3e2023d4bc7f2ed275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162f621062d5a11d317d2faaa4bcccbcfa7a5e9fdaa3a9047d2cf4c383632433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6da1e386382c3bc02d9a9cc76701a57ae2f81935d7c347dc9b4f430998bff295"
    sha256 cellar: :any_skip_relocation, ventura:        "2284fa8832d4e2ac412c376f34058043a8302b684a80aa71d5c01478ff833ae9"
    sha256 cellar: :any_skip_relocation, monterey:       "bdcc828905c03d9f5db4f5dd4aa009cb3383fbc131862be5523f6fb24942ba9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f4f07bd9edc68cc529a853794fbe99652ea5f7dc11e529d9aef09cd6c07b37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6bcfd6b5e39b3d6d7b55d0c0b7350195aa497bf309874b8e57605c7aa55067"
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
