require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/refs/tags/3.1.9.tar.gz"
  sha256 "35aee4c380d332355d9f17c97396e626eea6a2e83f9777cc9171f699e2887b33"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:   "1c539980a1190ae7468247a0ce16a82a557ff57767943c69a2b4048af72c7443"
    sha256 cellar: :any_skip_relocation, ventura:  "5e752c1b06eef72f76ab85796337ad9d8f214990f6c4074c8f420cab6582a477"
    sha256 cellar: :any_skip_relocation, monterey: "24737964fe1dd7d2af554e33db1f31a3128e675954e256dc054ca435ebe518c6"
  end

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on arch: :x86_64 # Installs pre-built x86-64 binaries
  depends_on :macos

  def install
    Language::Node.setup_npm_environment
    system "yarn"
    system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
