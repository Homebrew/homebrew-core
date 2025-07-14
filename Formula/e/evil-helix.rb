class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250601b.tar.gz"
  sha256 "920b36721a6a984c39208ea8825b1f0c68b0bf7d15e029e8ac6896c3442ccc78"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68dc4d8bef7fcc1f8f18a1c64517ad01e6ef805d64341280dddd7d1c289f49c1"
    sha256 cellar: :any,                 arm64_sonoma:  "06b4bbb5146045a2bf7a59b072dc714814de620a6a85fae8af74673d7f0b2080"
    sha256 cellar: :any,                 arm64_ventura: "5db089395faf9358a74b855b5bd8e4cbea2817d566043c64f895dcac813e3bcc"
    sha256 cellar: :any,                 sonoma:        "34f35cd6a6ab36ace85e8b13a26fc9472641cd14cea9cb8c7571e4b96891b460"
    sha256 cellar: :any,                 ventura:       "5e8789b7774a150997f7e48f777f2faf888197b35097168d69867098c3578dd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6584904445e70cca9317738c1f66adfa6760736a5b0583607d9c03318916b2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421f47a0feeae88f1a6129e38e95c6121937abe1b1432d5c1385d75b467b5c66"
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
