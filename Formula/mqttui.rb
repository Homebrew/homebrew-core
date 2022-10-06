class Mqttui < Formula
  desc "Subscribe to a MQTT Topic or publish something quickly from the terminal"
  homepage "https://github.com/EdJoPaTo/mqttui"
  url "https://github.com/EdJoPaTo/mqttui/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f17914822d05797a8e46447bc7cd0a649e083ee950d295db3c683d07f50269d0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4951b959c9d3eb86f0f9f76fcff8c2056c0e966c13695e630c0117a9afe5af72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee8ca7b76ef954400c49f98cc64f8a5fccd15003cfd91a5dc1f8222a7869e50e"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e6ab3d45799a95a656425cc524b1bf29cdde4435e692d14e353b8fccc40e43"
    sha256 cellar: :any_skip_relocation, big_sur:        "672533cf64855255f73afb5c1d1993b39eda5140dd142206524312959602e185"
    sha256 cellar: :any_skip_relocation, catalina:       "4d18fc32e180bb702892e8d6646c4aad2fd6cd3ee27f4b2843ea54b6f69c66ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ea0d06ffe4ffc9ef583a7d13953ee0e4813a794abdfdc51d6707cb3e891625"
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
