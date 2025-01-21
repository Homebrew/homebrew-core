class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "34caa9a540c107738b7156f8a67cbbd2d1f6a25522f964142943aae7d3099501"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785c02e782d4705b8856b3a2e7efafcf4316c96b82ef40f09b1941be8d890ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46e79fe9bd4008a24b0a4747578225a3c7499ab6325d0b4409df68e8ca511f6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cdd4e2052248e29d0c8d68187310d53cbaf4b64eee1d9b2fdcdc788f02bdf72"
    sha256 cellar: :any_skip_relocation, sonoma:        "446294e3a949a6d148b8f9910a2bd8de85f6fe20a63aeabbac6c05000dad1b72"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7ffb503ce101b1e29010d9b35e22f9816e3168cd89b7aa62bf4ab5e21891f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51fede45d21c05b4d32da4164d1305d8b8021b20e3103b18fa70f62b2b26a192"
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
