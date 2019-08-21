require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.3.9.tar.gz"
  sha256 "caf4ebfa64bd5ffd52e3d542b70a329be9225a926606188bd7451c2dfb2f23cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cf86eb384317f001ec7ad87b52b9f5bb0d5ec87ddd08094a55dfe19b8079547" => :mojave
    sha256 "4416a4a08e36b65ead4b59bf11c468018c5a0e3569313a700780918d293f7410" => :high_sierra
    sha256 "ca9d0340fc4f40db5347ce6313d469db8e851a1ea98cca6fa2b61b5e6391547a" => :sierra
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
