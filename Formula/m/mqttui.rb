class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "c8a65a1aef2e96484e09972de50fb6150a868cd30ce16d26df1466fdac1a6c75"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e82a2a2f7af29bb80c0d033ec6d8594bd00e043fef29ce4dc3a7178d32f64fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65186b346d1af06bc34f626f5f5bed22ca0b2eaf458bc1850afb3c07aa3b66cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e16b8a943e3b1190d5295eedf18ee730dad9a0090e3f5b88af24372410b3f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74704675148861672b2356a54a27113270df8066815ecf4307afd13558f764fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "77140e798abd551e3da4a845473aa93e5737dcb2900a2605d2810e93c051b5ec"
    sha256 cellar: :any_skip_relocation, ventura:       "e5827a0c24cf1a4989e249ef9425440dfc2254045945abcfd1481c60393ba195"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09274a577c3e10a6cb0092a7bb38fccf5d1c1c1fdbf7d5d79783e94b52d1f99b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb9b3f506f2cff73d1a6ef21969575a3e24646be804577b179e5735666dbe53"
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
