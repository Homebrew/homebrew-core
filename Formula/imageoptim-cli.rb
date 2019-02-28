require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.0.4.tar.gz"
  sha256 "c26ba12425f100ab16e992f607e6d69527a6572b55cf287f5321a62ee61af390"

  bottle do
    cellar :any_skip_relocation
    sha256 "40bfe00ed46ac2364895249f42003e3e862e737c80fe7a4ed9c6264ba96989e3" => :mojave
    sha256 "22d4d21459a4cc8754d11b0acc953c816256d6510db2bf61b53d945bfd4557dd" => :high_sierra
    sha256 "bffc58868deab95f726d08ceba4060549a8d631a38f7c7978f7373a33fa84532" => :sierra
  end

  depends_on "node" => :build

  resource "node" do
    url "https://nodejs.org/dist/v10.9.0/node-v10.9.0.tar.xz"
    sha256 "d17ef8eb72d6a31f50a663d554beb9bcb55aa2ce57cf189abfc9b1ba20530d02"
  end

  def install
    # build node from source instead of downloading precompiled nexe node binary
    resource("node").stage buildpath/".brew_home/.nexe"
    inreplace "package.json", "\"build:bin\": \"nexe --target 'mac-x64-10.0.0' --input",
      "\"build:bin\": \"nexe --build --target 'mac-x64-#{resource("node").version}' --loglevel=verbose --input"

    system "npm", "ci", *Language::Node.local_npm_install_args
    system "npm", "run-script", "build"
    libexec.install "dist", "osascript"
    bin.install_symlink libexec/"dist/imageoptim"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
