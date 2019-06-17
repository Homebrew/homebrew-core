require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.3.6.tar.gz"
  sha256 "9b8ad6bbea060b1ae67d1b7d42e1606c9d649f58e1e92a5a4cdbcea82a4bffec"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc1de1355034820e8bc182ad53ee83fdda5221c3687154debe726ed5349bba0d" => :mojave
    sha256 "357dacdc6c1d2f429255f4713476e11204aefd7809620659637a4687baeb1a5e" => :high_sierra
    sha256 "c632177be9b6fc682da030bfcea66d20891a1f542f60954d960f524e28c94c0d" => :sierra
  end

  depends_on "node@10" => :build
  depends_on "yarn" => :build

  def install
    system "yarn"
    system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
