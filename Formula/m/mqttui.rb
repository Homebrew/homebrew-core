class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "98cd09e4c81b89be12ea65efd6c88890324c826965bc24d12d40e5449f3616e7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21dd6e39ef549c6703efe250db24bceba6c612c8aa237118092eb8cf546d8b77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3e8ddf45e29222b542dbedc0e2e45deec9de8eb3788339c626015ceaba74ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827a2e3fe86dcb7ccedf5f7ec790376bfb05b2ff79a2f041cb881e1c946d84d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff45a6abce9ae8a48ee5f6112432e1af6354edcafdf980754ad24a6dff98c29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "553f92c13c55fbfcaf1e3c0cd8bd39942c2fb0ad9f9fade702806e102daeda41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed8f9f0c4ee40ed048cc743a4edf811a61844d183cd2d0d4635274295c8f734"
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
