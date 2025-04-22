class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250413.tar.gz"
  sha256 "60e0aadf9e833e0b579028b7f21803722b3705d74dd062bac96ff8ac4da91a5a"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c8584a1bc7048842c36c3d042edcab3ccfe52ab91de4d5826a3223de50b34ad"
    sha256 cellar: :any,                 arm64_sonoma:  "8beb27e8167b0df9392b01a0e89fce4ad85279997206a1ae1912b27c436739f3"
    sha256 cellar: :any,                 arm64_ventura: "c34a0d85c771e2b3b50d6356d6c3ff3adf920fb3904253c76c0d6063d09820ab"
    sha256 cellar: :any,                 sonoma:        "533e9fce3a0c4e68b0df0060025bc20b1b749ce442bdd880babc46e40a6720bc"
    sha256 cellar: :any,                 ventura:       "9e404ef46aefa053a4c2eac1668fb5c3f2a527d99179e8876956601b3692750a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa18bf850af8c53b1fca9b0eb2e8a4febb66cae9b3d7f7df5da86322bca976cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067ae88beeaabfee440870efa7a0b56bdb3ad648ef3a962160551b2cf0f9ad17"
  end

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    file = "https://raw.githubusercontent.com/usagi-flow/evil-helix/refs/tags/release-#{version}/Cargo.toml"
    version = shell_output("curl #{file}")&.gsub!(/.0$/i, "")
    assert_match version.to_s, shell_output("#{bin}/hx --version")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
