class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "b51b7b92c7f7cb7a418bb91f49479a1c388e336d0405298633c4fb7e1edbb9b0"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ade651058f420da579a8510d727509618a24e368d657600f644558894d6e209a"
    sha256 cellar: :any, arm64_tahoe:       "7d140f4c61afae48c439b06b4e13c1267b0e818e839588cbfca704bb1850d346"
    sha256 cellar: :any, arm64_sequoia:     "f00515b8d6e920f319a78eef8389ba7a235659b1be570e963f792f326180f99e"
    sha256 cellar: :any, arm64_linux:       "ca884f57a764a211ba24f35ba7df2906c8ed8dfc0f5ea8a900237c70d32635eb"
    sha256 cellar: :any, x86_64_linux:      "b2c5d1bdfd1400b4e1d2be38df6aacfa00a499e369d6565c0a20cf42e2a3d2f8"
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
