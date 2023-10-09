require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/3.1.7.tar.gz"
  sha256 "e2bff77c2cace9d28deb464c92dcf393b98baab30439541e2dc073ad1c0b9caf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:   "ebb436e0f4e7dd0cd79e3c1b4265fb20ea5dcd207d04c87df085caaee3adeb5e"
    sha256 cellar: :any_skip_relocation, ventura:  "e917e31cc5dc859407c54240b43dba811dcc9f179072b5665f6439291b57a5be"
    sha256 cellar: :any_skip_relocation, monterey: "57ee8f591ba12ad1579c41899c2e0722f70915ef59d8cbde9fab000b235a79e2"
    sha256 cellar: :any_skip_relocation, big_sur:  "1ff71fe45f65bada934ed0c002ccfc0f484db1c86c8907cdbc4fb3a5dfb3f37c"
  end

  depends_on "node@18" => :build
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
