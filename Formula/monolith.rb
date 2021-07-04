class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.6.1.tar.gz"
  sha256 "dc08e6fa786c2cdfc7a8f6c307022c368d875c172737b695222c2b2f3bfe2a72"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6cad2204ac16bd7e824be65cf1563bd5017181e1297c1932fa31f6e143ea9d2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8bab5e8bb67c954ea638ad651d81c6ca2fd4ea9acc1baf2fb0e4249752a4b5a2"
    sha256 cellar: :any_skip_relocation, catalina:      "961186a1e4de9a853830cc536eabb84a2f4d7ec79fd56fe0373980274d265f18"
    sha256 cellar: :any_skip_relocation, mojave:        "dd9b05cad1f3b21ab3748c366e259dfadefb70467527676d63f6105dc1dae880"
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
