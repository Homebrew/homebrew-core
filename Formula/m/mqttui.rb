class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "64453143e36f59a2fbb0dd67b02437b170d82fa15daf492cff2750cce0f5c126"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d92ce31d6947d8cc59b79b3b2981fd5dbfefca24b7eb6edb19e5423b60df4d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48685db4c03887959fefa286aebb5fde71ef299628d23ad09d86042f06a01f59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15f32c048545ff1bf64b6e1ee3ad6fd9d69c222d099fe3192ca1ca37925712aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7795afa5ce635ffc40a7a795e8355205d842f28204aee95b4dc3cdf202430be"
    sha256 cellar: :any_skip_relocation, ventura:        "2d69821b3c53d01f3f446956981e6d547f26078ce068c3e59c36e95cdd51a733"
    sha256 cellar: :any_skip_relocation, monterey:       "a7a9ceda7689574b9a0a2a2f550ec4edef1207f368eb845bf67ca6d140364cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6ea9fff76a2f36fc2fc64991e0e2ad593248b53143bcc3f63ed9f92fd34e31"
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
    assert_match "Connection refused", shell_output("#{bin}/mqttui --broker mqtt://127.0.0.1 2>&1", 1)
  end
end
