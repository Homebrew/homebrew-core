class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "34caa9a540c107738b7156f8a67cbbd2d1f6a25522f964142943aae7d3099501"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "852000bbb6154a15aaeb04c16dea3debb51a37ae6e2aca62865703b69710897c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78a4b50a7de81fdcf692ada8a6b8cf8ce4422f073f1eeaec4e342f311352d8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a83821074d07516d9b80c32718727bc1d2a62f772b2be2a8956493cc4682d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e95d225919d3ec405260a89a3c3cd3cbc273331ec899e29efb537884685ba337"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e26d91c0f38ed79f5d6afc91f7a5781fd000e0dc70257c678f7260718a3d2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "ea861b285a01185fec5ea5fc6663c8f99d205f5ca9158b40e7ed1068545cb7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "f7abd6ef1e8b517472124b35e7dc94127886ea30aabd2d7cf950c253b3438a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebeadc572d78a107c0b0e8e109804d2c17adc3a41d3abd4adce818378965dd2"
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
