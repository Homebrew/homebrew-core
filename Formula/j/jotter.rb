class Jotter < Formula
  desc "Jupyter notebook TUI with Vim keys, inline plots and rendered LaTeX"
  homepage "https://samox73.github.io/jotter/"
  url "https://github.com/samox73/jotter/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cd4c41d6fb7d5cbf1f6206abe4e19d94a20e5f9e1ba9ef58c5ca194af9684cb6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/samox73/jotter.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

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
