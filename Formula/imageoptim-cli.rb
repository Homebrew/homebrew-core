require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/3.0.0.tar.gz"
  sha256 "f2640f5ef36e9b89bf09e4d096cf838e5480692fbd24c9eea9373f20aecd38c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "01b9a1e6165475d8ca283319e8c8726d598ed8a7805f46ee9186182e289f42e6" => :catalina
    sha256 "fb5c6f924a9aa68016234f45f68120d8aa744df57781b1430229c6ff610ba777" => :mojave
    sha256 "9d36cfd82d6283c3014ceb1b7dc72b6a8bb1b780849e7cc70c79468539c19600" => :high_sierra
    sha256 "6fd8a9f1f82cddca4572c85eb2f577445b732791a3056c80a4dff6933ae6079b" => :sierra
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
