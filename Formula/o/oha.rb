class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cbcb9dbeb741b3cd2207011c117b2ee82f1577d49f4f8be3c07828552ba24c7a"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17ea96fb9793faf402bab8bdd505eb0206d0f3a3c2030fed1049986c466c7e34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15f42fb67edb3822f3befb0a1208e6305d323fcd3e69bb881d39be871e13dfb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3bfb683efaa8d99d768cd5e932ffc335585456bf90f6493d92fe4f7600e3b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a41898c1ff89de61988eede459b1d5e8c2a532d217e69e0e336c3facc73b2285"
    sha256 cellar: :any_skip_relocation, ventura:        "c77eb4dc87eee9543128a7e13bce0d4478b42ce2104bf6d90fbc3e45a321217b"
    sha256 cellar: :any_skip_relocation, monterey:       "e32326f8bce535ced105e1787b73d00f523f66dccbb8afc722f173dc2a4e552c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e102ff8a6130fa465868678390312f77478b1506e2e0e2018aa655b90350f9b8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
