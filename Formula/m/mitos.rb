class Mitos < Formula
  desc "Fast and minimal text editor"
  homepage "https://mitos.computer"
  url "https://github.com/mitos-editor/mitos/releases/download/v0.2.1/mitos-v0.2.1-source.tar.xz"
  sha256 "c8723ee283415ed6de8d6daf8cc0086a5d15582b1b16b9499e8c63e653988bc8"
  license "MPL-2.0"

  head "https://github.com/mitos-editor/mitos.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args

    # Release archives already contain the pinned grammar sources.
    system "cargo", "run", "--locked", "--package", "grammar-build", "--bin", "grammar-fetch" if build.head?
  end

  def install
    # Write compiled grammars into the build tree's runtime directory.
    ENV["CARGO_MANIFEST_DIR"] = buildpath/"crates/term"

    system "cargo", "install", "-vv", *std_cargo_args(path: "crates/term")
    system bin/"ms", "--grammar", "build", "--strict"

    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"
    bin.env_script_all_files libexec/"bin", MITOS_RUNTIME: "${MITOS_RUNTIME:-#{libexec}/runtime}"

    bash_completion.install "contrib/completion/ms.bash" => "ms"
    fish_completion.install "contrib/completion/ms.fish"
    zsh_completion.install "contrib/completion/ms.zsh" => "_ms"
  end

  test do
    assert_match "Mitos terminal application", shell_output("#{bin}/ms --help")

    health = shell_output("#{bin}/ms --health rust")
    assert_match(/Tree-sitter parser:.*✓/, health)
    assert_match(/Highlight queries:.*✓/, health)
  end
end
