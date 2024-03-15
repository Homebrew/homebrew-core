require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.13.tgz"
  sha256 "7dd66177d6e5d0d6d84f0e293a3b01aa3588ee69d5c79f401ecafdf6718faec4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12e0b7716b2ee8349acef2ccb050e39b806c3b780f069a2d8b54cb5eb06d1cf2"
    sha256 cellar: :any,                 arm64_ventura:  "12e0b7716b2ee8349acef2ccb050e39b806c3b780f069a2d8b54cb5eb06d1cf2"
    sha256 cellar: :any,                 arm64_monterey: "12e0b7716b2ee8349acef2ccb050e39b806c3b780f069a2d8b54cb5eb06d1cf2"
    sha256 cellar: :any,                 sonoma:         "91d903a9bdfab36bbcbb4672303ddf44f387e985ff62fbf1d61f1d01f3d64797"
    sha256 cellar: :any,                 ventura:        "91d903a9bdfab36bbcbb4672303ddf44f387e985ff62fbf1d61f1d01f3d64797"
    sha256 cellar: :any,                 monterey:       "91d903a9bdfab36bbcbb4672303ddf44f387e985ff62fbf1d61f1d01f3d64797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ca7aabd9dd9438eab6ae94080e129c959808189e6b0b1828cec5c8af08ebb9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
