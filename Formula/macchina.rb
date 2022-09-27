class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.1.6.tar.gz"
  sha256 "1183b3ed710579e6a3fdb80ef63a9ee539ebbbe56764fb5fa3c4a0249d0eb042"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af2680f742ec266a24455e2036506bc7dfb9b4d39a8ead427b4bdd4a3c2cb44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c0ba3adeda6e310b8e285d29cca63f857fd60147675573b471dc2c95fa1d6c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f243e84263f78c5283a5fefb8967c3bb40b8b6b26fec062f2ffeaec5fba078bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "429b7051fd97755ef897be274cb76b737e74f2143e2b86d456a93fee013782c2"
    sha256 cellar: :any_skip_relocation, catalina:       "af117e1c8728e8965894527348707922a84d4e9cf85b08a2998527489c667a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df30c0046dcec8acc13412c40f68c9fe94da6ddaa385b08dfa29649d7f862a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
