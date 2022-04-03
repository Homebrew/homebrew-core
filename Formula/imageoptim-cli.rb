require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/3.0.7.tar.gz"
  sha256 "ed1a36ccb0e960152eda6b3d4c422ee355c8cf8271f1f8e71141a286c4d647e5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "5e330d75ae3187599414a272f05823d9e2e829cee4d4e75ca176e0e62aea2cdb"
    sha256 cellar: :any_skip_relocation, big_sur:  "633de8d348a6618d839ff4e16694c8634d59accafe13488cd72c88f44386cbe4"
    sha256 cellar: :any_skip_relocation, catalina: "633de8d348a6618d839ff4e16694c8634d59accafe13488cd72c88f44386cbe4"
  end

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on :macos

  def install
    Language::Node.setup_npm_environment
    system "yarn"
    if Hardware::CPU.arm?
      system "npm", "run", "build:ts"
      # Install nexe beta version to fix build issue: https://github.com/nexe/nexe/issues/804
      system "npm", "install", *Language::Node.local_npm_install_args, "nexe@4.0.0-beta.19"
      cd "dist" do
        ENV["PYTHON"] = which("python3")
        # `npm run build` executes both `npm run build:ts` and `npm run build:bin`.
        # The latter command targets 'mac-x64-12.18.2' and nexe doesn't provide arm64
        # binaries, so need to use `--build` flag to manually build Node.js from source
        system "../node_modules/.bin/nexe", "--verbose", "--temp", buildpath/".nexe",
               "--build", "--target", "mac-arm64-12.18.2", "--python", which("python3"),
               "--input", "./imageoptim.js", "--output", "./imageoptim"
      end
    else
      system "npm", "run", "build"
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
