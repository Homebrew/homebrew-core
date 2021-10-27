class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.17.4.tar.gz"
  sha256 "c50f06a6561f8e5ac5e5eb5c13cbd612ef810fc9e57d470d7793e69e243b4a52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8bf7ad61aebf1fd9024b53436c113942bee88eb7db23bc57c0c7d968ff8baa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49eea0a06c946f0f3ef485cfcf79997c98acce4464a481184ec76978e3f117bb"
    sha256 cellar: :any_skip_relocation, monterey:       "fca10f812d48c5b51ea5374642b46d3355ca47757fa7f50d6785eff179c9132e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b508cc2831cc0c9b1f708342c16447641e4885c6477403e669dd547a355883a"
    sha256 cellar: :any_skip_relocation, catalina:       "ee4cb9dca99bdeb3899d6b52eb09b573470df696e7ef16c5898998465827f9dc"
    sha256 cellar: :any_skip_relocation, mojave:         "d73ffab8a234961c0028268d622bdac4512cff9f17f5f7defc2c831bc91af8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b58a7da1188741a7a462bdc33d1ad49b5172924873aed23c372537b26e48bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
