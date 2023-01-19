class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.61.3.tar.gz"
  sha256 "93a5a750e21ba52b9fa6cccb967d4022a4de83fda48d1602579b7449e50a7356"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44108994e08cabb91ec491a65e7f44460d71e6ec1f2d1c9b330d9f2f17a409e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "623d51faec3889d9ff20f74fb046af1c069c952c177cf294c595e0b1089ad486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a999b27c2ac0ed97f429d2061ed3a159fe4e21aedb19d032fa1cdc795cd8f52"
    sha256 cellar: :any_skip_relocation, ventura:        "de3a91e5a7c7f36e9b8b8e50976ba18fcd3c63ea1f3a7f390da60bc104155e87"
    sha256 cellar: :any_skip_relocation, monterey:       "63303329adb6582ced2518f9195224a4a34f74f0079d71deff55967e6e62646c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be51be6ba66445c3598fddcf11599c947b92920cb379c843ac235c42d5427ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7779c4955b38e5fc151b3d0438ac2e40dbd7fddac9f3e96bdf3a52f7f6e36b0"
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
