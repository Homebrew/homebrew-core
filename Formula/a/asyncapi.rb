require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.14.2.tgz"
  sha256 "8c6ae58f20e47ed2fc214ece1820245c96a407ceb8e65861ce206bf17548feaa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11a38a6bdae33827b40223608f36c4782defd965ff54d6e49ad20fbb8f133287"
    sha256 cellar: :any,                 arm64_ventura:  "69464d483a206a990bdaa5c3b906b75452639b33bb4cb5abe959380569640e87"
    sha256 cellar: :any,                 arm64_monterey: "b06e8e53de8fcfd36bfdbe72772aa2d42867f9e1b891258d4fff0fa4649ab1db"
    sha256 cellar: :any,                 sonoma:         "8d4b6e2bc008d8afb9ddcad77d46af6ba9a73be5049ea287a54cab7f06e83e76"
    sha256 cellar: :any,                 ventura:        "1d9ab80bbc240f6804b2d19fbf1e25098421f78cf71e2eee80cc3d28a504666b"
    sha256 cellar: :any,                 monterey:       "61ca4e26c5d08cf2ddfa7897583d2d93dde773272f3e0af521b9c802dd287aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f4530c3ec58cac732730b5abee9f66fcc5f9da89b14c7c9b6f929bc6c77ac1"
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
