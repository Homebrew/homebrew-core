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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a773e296348e3eefcf67f3b5101d88df39de5a2cf3746ddc67bb14542620c105"
  end

  depends_on "yarn" => :build
  depends_on :macos
  depends_on "node"

  def install
    # Adjust package.json's bin and add missing shebang to avoid bundling node
    inreplace "src/imageoptim.ts", "import chalk from 'chalk'", "#!/usr/bin/env node\n\nimport chalk from 'chalk'"
    system "npm", "pkg", "set", "bin.imageoptim=dist/imageoptim.js"
    system "yarn", "install"
    system "npm", "run", "build:ts"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
