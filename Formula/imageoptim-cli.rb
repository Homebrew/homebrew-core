require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.0.3.tar.gz"
  sha256 "47fc8a1f14478389cb71dc8a03ac6b3176ba311d1a2390867b792b60ef209fb3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1c507116de8b59a3437eb91b73ee7997b91f54409e7a57b84c9bd92aae88008e" => :mojave
    sha256 "32d15b612091c5a6efe37374f6a49245579561e9a46b651875fef52241efc76a" => :high_sierra
    sha256 "1df36a9f85175e39aeadde4dadcef277dd948c84a1ca8a1dd396e6d25894e3c0" => :sierra
    sha256 "1f061b2328960f327bdba6e6ef3447d4d4c789a3bc9e8e0b6229a21d25ee7533" => :el_capitan
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
