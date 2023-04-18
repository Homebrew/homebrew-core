class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f17914822d05797a8e46447bc7cd0a649e083ee950d295db3c683d07f50269d0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4091e8b5c8b0f2abe912829985614a3cec02b1a6012f71511a8d4d887406efd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a273fd7474c402a5615f211ad092ff55ed22a7b817a2af1c80b250e9467fb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4933a37e857607d1bfe617b442780e72b518fab7119e023cc3067a6ae5abe8e"
    sha256 cellar: :any_skip_relocation, ventura:        "5e24a34e97313091fef97c2354d3f1b189f717af2dd1d225712ea8542013bc9d"
    sha256 cellar: :any_skip_relocation, monterey:       "49c41cec799c0aa71594fb7ccf0adc6d3a9383f86982bfdc70838c6dd29ff24e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3a5ddb75337a9f3fb4e14262bd78425dc1bf320a53e1204ca0bb537cc75b7c5"
    sha256 cellar: :any_skip_relocation, catalina:       "08d009cd278615ef390f2cb2d7bfb1aa254ed322b2c8c68e4256720715469b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98186b9ed5ccf1d0d6b2bc03e945e0d40dd40df38e90afe309f59e288aef4d02"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install "target/completions/_mqttui"
    bash_completion.install "target/completions/mqttui.bash"
    fish_completion.install "target/completions/mqttui.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mqttui --version")
    assert_match "Connection refused", shell_output("#{bin}/mqttui --broker mqtt://127.0.0.1 2>&1", 101)
  end
end
