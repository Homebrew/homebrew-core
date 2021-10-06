class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.8.tar.gz"
  sha256 "a912c9ed7b826c969012308a8a7e120a3c3af8b8bf4cf1e062927c9301ffb178"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "139109ab870d052bf41f3e6bfcfef808cc0921fd1641e369d06dc1dffdf26f91"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a92ce042ab6783882785c6e986b1e9f023e49db8e52a207ea4d58401a4dde37"
    sha256 cellar: :any_skip_relocation, catalina:      "61a40872ae1b68efdb1254add911cfd3d306841f6dc70ae1990f369dd3499e49"
    sha256 cellar: :any_skip_relocation, mojave:        "5f088d329b8a192b2c7573c3a238ad89fc16929dcc884f119f58ddae6e608deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a53e1a198126ca4891390ce511b4a9f945f8b69e98b1ce6a42dfaf25449aa96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
