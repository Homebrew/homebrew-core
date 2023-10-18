class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "76d39f14920eb1cf1a65239f1e54c840f20b35c2be96f074819be5175427a7e7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bd6ff528221a513feb78382cbbe148c460c51f460e195a4c0d4f220fc014e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9fe6bb6a5753349aecc5cc9de4417502ac4a657eb4a97d3c1ca161ae1c7dfd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "992bd414eb11c5e87b9df377c7764b988f859635639274327f97a658196afbda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "549bee00ce591da8f9ffa26555f41edc109f542429c4fa33319a7049f1a51dd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "383153a910998cd36d91361bbd0cdb1fd6aff62d94ddb89e6b798565dc5ebaac"
    sha256 cellar: :any_skip_relocation, ventura:        "e1b637bda078e18ab98ee9ab126d36908797370ddb6d2303c4e44084cbae0e41"
    sha256 cellar: :any_skip_relocation, monterey:       "415c21b31f21aa9373e0ce1ac136f77a94289209cf14e1a3f4565a2364dccec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8ab86d2f5ddd55fcc8dff7b9b51e584859e43c78b10a8623f893aebec822e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c18d14925c763052ce84b59f259a947856a73dfd70337c30f1cdfde8ae42dc"
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
