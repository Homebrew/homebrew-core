class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-source.tar.xz"
  sha256 "2d0cf264ac77f8c25386a636e2b3a09a23dec555568cc9a5b2927f84322f544e"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4e68c5975370f7be5918cd8c160798b3e1b4085aea62403181924e8685256b6c"
    sha256 cellar: :any, arm64_tahoe:       "0a55fa8eec03e38aaadfb2df8cf3f09d1bf9a1078c12ba7bbfded3b1253c7dbc"
    sha256 cellar: :any, arm64_sequoia:     "590d036799387c9ca8dbda933a8c0fbb2361a98932973d862f3e08960e1a6556"
    sha256 cellar: :any, arm64_linux:       "f61f3b4d8f06fe37b72bd67a51cb4383b64644eeb1e617f717af7e69d4b66245"
    sha256 cellar: :any, x86_64_linux:      "acb6fd5cc7046ec666d02d28aa4aede836f539c759af26f8103b500a077e49f7"
  end

  depends_on "rust" => :build

  conflicts_with "evil-helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"

    # HEAD builds need to fetch grammar sources bundled in release tarballs.
    system "cargo", "run", "--locked", "--package", "helix-loader", "--bin", "hx-loader" if build.head?
  end

  def install
    if build.head?
      # Build the fetched grammars explicitly without trying to fetch them again.
      ENV["HELIX_DISABLE_AUTO_GRAMMAR_BUILD"] = "1"
      ENV["CARGO_MANIFEST_DIR"] = buildpath/"helix-term"
    end
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    system bin/"hx", "--grammar", "build", "--strict" if build.head?
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"
    bin.env_script_all_files libexec/"bin", HELIX_RUNTIME: "${HELIX_RUNTIME:-#{libexec}/runtime}"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match "post-modern text editor", shell_output("#{bin}/hx --help")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
