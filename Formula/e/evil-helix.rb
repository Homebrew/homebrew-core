class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250104.tar.gz"
  sha256 "b03c78ea4cacd11eac8c2fb2e40c4a20e5d6d29ab151e3176876bf58c298b7b5"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef875c469d84849e51573b50474d2523c029f10309b1ed9eb15bab238893205c"
    sha256 cellar: :any,                 arm64_sonoma:  "7aad6857cd93c4e16ae9481271dc47f5f100e32c4be3609e20bc650c53ac50bd"
    sha256 cellar: :any,                 arm64_ventura: "84890f45493d8c9477111ac3435f64858990d372ec0de53896810eed8955e32e"
    sha256 cellar: :any,                 sonoma:        "ca3d946010aa2de2dc7b4a5888701217812bf63c4a8615f476b7ff87138f0090"
    sha256 cellar: :any,                 ventura:       "f74b75ba30308f77b8d5ba83b78d8f601ce9cc0056bb3c408ce37c35783bc2df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c55c8de31ebd6d53335994a2f10c0ea7eb38c5fc45091c70c6ae3497a9d6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ab70aa754ed371252ca56342dfc44a8ee188d1f167143fbece4f7fc436b56f"
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
