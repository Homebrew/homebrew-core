class Jotter < Formula
  desc "Jupyter notebook TUI with Vim keys, inline plots and rendered LaTeX"
  homepage "https://samox73.github.io/jotter/"
  url "https://github.com/samox73/jotter/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cd4c41d6fb7d5cbf1f6206abe4e19d94a20e5f9e1ba9ef58c5ca194af9684cb6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/samox73/jotter.git", branch: "main"

  bottle do
    manifest_sha256 "e640cd8825e06b04367147dadd5a5ebf61f2cf6f4259d7794f35ccf6bf164dc5"
    sha256 cellar: :any, arm64_golden_gate: "f04cad751637782efebcc5771097b217cd5eb99157498aafca8f84a8356ed1ac"
    sha256 cellar: :any, arm64_tahoe:       "cf200389686200b6044891c7a3c6abe3a2e44b623de8cf019990b7bd5cd5a2b8"
    sha256 cellar: :any, arm64_sequoia:     "b02fd5dfc844bb44d0b70e34daa9f7bfa860f04841e68d6c113abfb49ae50800"
    sha256 cellar: :any, arm64_linux:       "ce372b177ebe993510e62a8e4bf07782ea9090daa70f427e04351e36a9b340a2"
    sha256 cellar: :any, x86_64_linux:      "039e71c5b06037f1ca2a3044965b8670122c1795943c0c04ebb8ef5616a520e2"
  end

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
