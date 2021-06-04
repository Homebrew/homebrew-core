class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.5.0.tar.gz"
  sha256 "0280d811c6b74fb84066a059db058d0008ff24ce128d4042659681d3aedf99cc"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "542b404b9dc55bf6a732ec6538e8dff34767ea5cbcccf2285410f68f93dfc5bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b8ef403bfe2b324d29a4f4afb8d443e42b0e0d5df9a54a4883f3d0188fc69ec"
    sha256 cellar: :any_skip_relocation, catalina:      "af02927793474654eea0f0837cad3a9230f377f8fce03e19a9e5013554ba0aa4"
    sha256 cellar: :any_skip_relocation, mojave:        "a5b4c2c2fe78607b13d3325031ccbae85e3b485ebe13392555048053769620d0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
