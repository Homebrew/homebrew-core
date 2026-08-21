class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "287de6901f43bf1d879be25acffb02f7601e023afc90b11c8e0504e757a6589f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63fc5e813bc6e2d15b0a303a97c4e85564518b0544b7e316e78baf1e1358b889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa83e67d90b3d6c98a3dc1adeb5d2579c2a9943d802dd17b0c36c28c07e9548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403cec21c8be70b0f4604b230c15d1e85536f42a38c7bfbd394dc508b2261ef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0adbd8538578615edfec23a56ca12c06a90d3c106456ba776adec82c43f6e278"
    sha256 cellar: :any,                 arm64_linux:   "1593112b3dc6628198ad7b7f9d9e48c49b69464a1d36e98ab42f6337a9a7ca92"
    sha256 cellar: :any,                 x86_64_linux:  "5f8f36cb8bdeb9c4e73ac0c185850e7f785e15b1ca2f8540f52d83f83a265545"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/mqttui.bash" => "mqttui"
    fish_completion.install "target/completions/mqttui.fish"
    zsh_completion.install "target/completions/_mqttui"

    man1.install "target/manpages/mqttui.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mqttui --version")
    assert_match "Connection refused", shell_output("#{bin}/mqttui --broker mqtt://127.0.0.1 2>&1", 1)
  end
end
