class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "542cb069def17c9799d62fafd2b3051fd70ff31fad54f83c334f2840bdb6b1cd"
  license "GPL-3.0-or-later"

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
