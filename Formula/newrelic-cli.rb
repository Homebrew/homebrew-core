class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.2.tar.gz"
  sha256 "dee9702a43e150c2e233f432b97c2a47cc963f083704077503665e7f45f3b491"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "417d1a1ab5d11bfe026a10cdd026579c15e764382696d808bb7e016826a8327d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64118c41599e1996c31eebc3ff8de9bd8f3b1604f65e5f51b7f35197eb075122"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e70b24bf07a181a488e66ea6bbbf16b0d5041f05cbc509110e0100f8f773bff"
    sha256 cellar: :any_skip_relocation, ventura:        "25b3c5dcadba4324caf2364e0f36e1cfdcc2d98b6d25402c8064f426963987e1"
    sha256 cellar: :any_skip_relocation, monterey:       "25d9f10075f816af09f393156314d379a4e3e058692d22bf0f547690eb950fa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9815e7a736d7cbc7f740990b5287e297bce5b5b62ad167859ecb12e6b58f8df6"
    sha256 cellar: :any_skip_relocation, catalina:       "061c4c697a75a573735000406e799c8f5f09bd02dea57538a3e24e00d64ba299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca01da115c0b1d5aec1a34d741e5d7e7473218a77cce72bbd89cabcddf92ba02"
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
