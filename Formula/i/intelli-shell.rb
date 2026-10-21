class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "7f785558cb60e9fb839e8ef0fb8964ca3341ce4ab090e08d4ce8bf9627f173ea"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b73a5fcb281f71d90632be77d93a2c5f49b40d8efe2f0b6ecfdf97fd2bd5305b"
    sha256 cellar: :any, arm64_tahoe:       "3bf51fe8e887746033a6ef9f42f5df97500ba89dfd8566dc97eb1661b97daa6e"
    sha256 cellar: :any, arm64_sequoia:     "d275e4b14230e41611d8b8cefe90e735e641d7f20bf6b0813636379b129e7767"
    sha256 cellar: :any, arm64_linux:       "7872d8f120a149bd822d0d62c1d2b909916b7d70584f6990b3cb6e15d041c7ad"
    sha256 cellar: :any, x86_64_linux:      "2a0feb03d176f39468d2e673360faa2f73fd72ee51fe9f2136f227ea7a44be6a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
