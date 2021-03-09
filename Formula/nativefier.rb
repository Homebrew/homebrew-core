require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.4.0.tgz"
  sha256 "93ad382eccd95fee92bfe672a212d744146fdc7e7d7a8733ef11bda769cd59fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "455644b76c14e5368dd7143cb088585ee8516046218c4b92bb6bea039f6bca7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7d292d597c428a5877ef16dd88680641cfbff400744af59f9b289f8b798ee9a8"
    sha256 cellar: :any_skip_relocation, catalina:      "6482b8b85f0bb00fed867ce1351c3d28e581aec15f99880f28d0ba74ec70ee9a"
    sha256 cellar: :any_skip_relocation, mojave:        "acd62fbf3313466aee7c068a4b4c889fadd720e3061c5e11214aa913101b19ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
