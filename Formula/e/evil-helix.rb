class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://evil-helix.github.io"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  stable do
    url "https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250915.tar.gz"
    sha256 "1a5dc826890eede336b2f2cabbb1bb19b3e25ebbc0c42ac09eb7d9348bbf27cc"

    # Backport the gotmpl grammar switch, its previous repository was deleted
    patch do
      url "https://github.com/usagi-flow/evil-helix/commit/7ea891969ae2592403ce1ee2c84fa119133c5cea.patch?full_index=1"
      sha256 "d9c4eb16ca38063c9bd4d40ec77dc3ee334d16ba6af14f38273c3a319594219e"
      type :backport
      resolves "https://github.com/helix-editor/helix/pull/14746"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "fa2eb1968aeba1afd29b1ca4d2dbb2e3405e9cf4232cfb896ac8f46e8a69cb36"
    sha256 cellar: :any, arm64_tahoe:       "6af5528b5378995f37aa0f49096968400036469e0d0b8281d891e7fb4279a058"
    sha256 cellar: :any, arm64_sequoia:     "828a3f90d5df9d7b1c23ddff5e90332a17f6643bf41f45150e7346b75865368d"
    sha256 cellar: :any, arm64_linux:       "91bbd88e027943f803083aa8b4b48bd05b63514344da902075e12f80f216a0ab"
    sha256 cellar: :any, x86_64_linux:      "3b22695460477c272a7d50996cfdae9c9a580bdd57c8dd038594c97705354d94"
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
