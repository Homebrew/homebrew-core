require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.3.5.tar.gz"
  sha256 "647849b7c8a15dff2ddf9dd054d70e6cfed78673bc1785c330c614f60cca83de"

  bottle do
    cellar :any_skip_relocation
    sha256 "40bfe00ed46ac2364895249f42003e3e862e737c80fe7a4ed9c6264ba96989e3" => :mojave
    sha256 "22d4d21459a4cc8754d11b0acc953c816256d6510db2bf61b53d945bfd4557dd" => :high_sierra
    sha256 "bffc58868deab95f726d08ceba4060549a8d631a38f7c7978f7373a33fa84532" => :sierra
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
