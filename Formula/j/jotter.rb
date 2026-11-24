class Jotter < Formula
  desc "Jupyter notebook TUI with Vim keys, inline plots and rendered LaTeX"
  homepage "https://samox73.github.io/jotter/"
  url "https://github.com/samox73/jotter/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cd4c41d6fb7d5cbf1f6206abe4e19d94a20e5f9e1ba9ef58c5ca194af9684cb6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/samox73/jotter.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "8c94e15848ad50cd69d7edebdfbdee57b8f09fded313bde2a207c56129de78c4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ed910ad37bb82785a674fd95293ca644e1d2ef02c599bed6c159fcadefa05b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f47a05c6d2cb85391375c99c71d08a09eda8ee2648d93028ac652266c8ce6d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6891b1300c160b07757ee73b1c1b100ee6903f1e128ec456ca429a0d28e127d1"
    sha256 cellar: :any,                 arm64_linux:       "4c41183c5e347f53958f834857d88423b81fc8d0a10bd5bab184e9bb6b31cf27"
    sha256 cellar: :any,                 x86_64_linux:      "61746144fb2ef866ca6d57778d1b3f68da64728b73308bd6831c36d3b26e0469"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  patch do
    url "https://github.com/samox73/jotter/commit/d70071b6a6b5346ae2f6a0805275d10b2b9e8f6b.patch?full_index=1"
    sha256 "579143062ed72e11dd9b8c945158c101c1c038f57af49132f9f452d305986683"
    type :unofficial
    resolves "https://github.com/samox73/jotter/pull/24"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"jotter", "--generate", "generated"
    man1.install "generated/man/jotter.1"
    bash_completion.install "generated/completions/jotter.bash"
    zsh_completion.install "generated/completions/_jotter"
    fish_completion.install "generated/completions/jotter.fish"
    (pkgshare/"completions").install "generated/completions/jotter.nu"
  end

  def caveats
    <<~EOS
      Running notebook code requires a Jupyter kernel, such as ipykernel,
      installed in your project's environment.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jotter --version")

    (testpath/"invalid.ipynb").write '{"metadata":{},"nbformat":4,"nbformat_minor":5}'
    output = shell_output("#{bin}/jotter #{testpath}/invalid.ipynb 2>&1", 1)
    assert_match "parsing #{testpath}/invalid.ipynb", output
    assert_match "missing field `cells`", output
  end
end
