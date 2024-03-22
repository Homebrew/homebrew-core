class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "f6b625ae76fcabb4b3c31b8b0302debc4df4d34934da6152dcc6f8d26a17a57d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc1ecf38a0c15a40acce2ff5f24dddecddf31b5aa2d3b332efaaef184fa63e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61f13c60faa0c57f90afb40e151c42c6fa843e326df82b43665d2716c3847377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ff367e6981866441b190892f88a25bd80efe3d87716ef6b2e4f946c7e5b49d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c65308fee148c4a903e4c1e09d9fdc1e8900f85d2497ee807649f4f8158aac61"
    sha256 cellar: :any_skip_relocation, ventura:        "7be13e1176425e4674e415bddeb26005223c05aa59bbef4432b079182421b702"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0b60ec724574c87292b3e3a039867bafaf9db4a24fc2a8df30448f3594d0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6759e1023e380f6806be749913a65fcc97c19fb0e45323551ee20f3c36a3f27"
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
