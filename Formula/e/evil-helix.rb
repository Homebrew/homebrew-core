class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250104.tar.gz"
  sha256 "b03c78ea4cacd11eac8c2fb2e40c4a20e5d6d29ab151e3176876bf58c298b7b5"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  depends_on "rust" => :build

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
