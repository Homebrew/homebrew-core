class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "d1a500b1700775a5e24754e2b1f29cde0ad5ad72776b6abe1973173a1a9507b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46e829bee4c3af621e18f87cbe25c5ea5b759e2811e5b69a89561d56cc2d74f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22a7483323e568ffc62a1891c07f5402f3d6e6762283ad3009ed6f5e3ebe025b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be5be415da4983f2a95de5ebda746ae1e7a99752680369eb9069859a327aed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b2b1c7ccddda2c640af2c518332edbfbdfb3c4970a351c6fb61ebd501d7e81b"
    sha256 cellar: :any_skip_relocation, ventura:        "33a9863155900843b4483da41e62d7b0c65d15f894f5b6c5d7f9cf316cc19afb"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2d71dd17d1a294265d0bd3d644c24d38bf484423d85222f6263bc824abb325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edfb4ce5ad7c2097989a85543d673e77630845244c4ac8d9b9f5b477e6c77167"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    output = shell_output("#{bin}/killport --signal sigkill #{port}")
    assert_match "No processes found using port #{port}", output
  end
end
