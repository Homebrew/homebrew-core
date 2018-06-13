require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.0.2.tar.gz"
  sha256 "65ccf26cf45012e20877bf7985b1f9d99cfef4ac3d0f1209dd6fa04ef02056ff"

  depends_on "node" => :build

  def install
    # Fix has been submitted upstream, but not yet merged.
    # https://github.com/JamieMason/ImageOptim-CLI/pull/166
    inreplace "package.json", '"nexe": "2.0.0-rc.28"', '"nexe": "2.0.0-rc.30"'

    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run-script", "build"
    libexec.install "dist", "osascript"
    bin.install_symlink libexec/"dist/imageoptim"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
