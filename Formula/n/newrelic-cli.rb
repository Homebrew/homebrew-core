class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.78.1.tar.gz"
  sha256 "a879ed8d3a078395d298e5e26a1ebb053258929724b0c27b36b4fb955ab2af78"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3a63e5cce912c7015782fd0e635412335a648a7f780152fa592166a32d9a638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aef794d247c7a1d1eec871e01fbfde9a650d07d0b37c91218a9d55eb7533b7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54278cb8c6674c51ca62ea4185460dde0ee94c4c32ab21f3173ec902dac0f884"
    sha256 cellar: :any_skip_relocation, sonoma:         "fee48bf3d7b0bd3f0c92bfc28aa5a57e330bb775898336a14eb2d38cfd3cc81e"
    sha256 cellar: :any_skip_relocation, ventura:        "87a5db455e15886b6502901a2994a6e68e8999556735addcc16acc494a2cad6d"
    sha256 cellar: :any_skip_relocation, monterey:       "185449918e44abae5d24aad93bcd779360f365187ffa6c204c04fb52707e5e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9cd1cb9bf44431c488cb2da815361e65a271d316c876d7baae9ec151c0d3420"
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
