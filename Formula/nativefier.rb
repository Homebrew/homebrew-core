require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.7.tgz"
  sha256 "58445f81fc9ca671cfffa12cf7cf2dcc1e5a011da7bee4297f18de497123b5e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ff8f0781e4d2f0c0eb19cdf118bb461120537b32ef852e6a83986877b1a4ad8" => :mojave
    sha256 "0103844189063e290aef722bd5f0741414e1234d4ca0d41f4a070ab8b338e075" => :high_sierra
    sha256 "a8a8ab5edec987caa1cb7cff560411592da6ccc3499a8b2ed5230f929ce2342a" => :sierra
    sha256 "6c9614291d3936c7ead5d050968748bfe557e5888852c9685df8dddb61ac55ce" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
