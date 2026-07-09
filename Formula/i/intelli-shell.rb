class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "3bb19e59f65e5076c549379cdd8bbe37ab38ddb45187f2333d4356f49e5b1f41"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "22e5bc09de34b3ed8342a4bfb8787a4d29a8ae501fa59a094886b9ce64ec811e"
    sha256 cellar: :any, arm64_sequoia: "5c36a03bcc346abecf17198df4e5f8b4975b1c5e4dbccfeadb97f66f9fa119a9"
    sha256 cellar: :any, arm64_sonoma:  "52b7296107b8e6654ce6e83f6a951bc862e430d5c2e6df5219506f5c494c193f"
    sha256 cellar: :any, sonoma:        "f3cabfd7921792db3bdbe48f4e56c36887fb983d52a51cdac9640179e228b8db"
    sha256 cellar: :any, arm64_linux:   "bb9b8ab9d2c017970d08560bedb3864a7060c7da6918f31ab16f4d6de9f4b107"
    sha256 cellar: :any, x86_64_linux:  "19db7acc6640f5ca464cbfc1360c4173e67cd017829ece87e5cdca2184761c62"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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
