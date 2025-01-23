class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/refs/tags/3.1.9.tar.gz"
  sha256 "35aee4c380d332355d9f17c97396e626eea6a2e83f9777cc9171f699e2887b33"
  license "MIT"
  head "https://github.com/JamieMason/ImageOptim-CLI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma:   "c2df0a56a557b3ed98d9240aea9c6f2d3edf899b0d0a1c3c8a1e1bd93c6d3595"
    sha256 cellar: :any_skip_relocation, ventura:  "d2efbaedd1472d061fc4cbd0bb9ca3e93d0070a8f73efaf8131320e91d50a309"
    sha256 cellar: :any_skip_relocation, monterey: "fb18de0c4c68f50c4239b1ca4374a56a0d6ba981d0e7597d54c4f32de4c0c1ca"
  end

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on arch: :x86_64 # Installs pre-built x86-64 binaries
  depends_on :macos

  def install
    system "yarn", "install"
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
