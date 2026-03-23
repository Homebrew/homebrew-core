class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.9.tgz"
  sha256 "e3e7a6142ae01113c7e2c39412b2f1ed74cce727f22c5665c3d8ce6a3fece3c9"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a0c048b505c0172033daebe91ee545f2445faa3e01b9f327a9f904898cc43b8"
    sha256 cellar: :any,                 arm64_sequoia: "4b2634705c772c330aa357244a907314b3d309e7b119193498ca04e25d43024b"
    sha256 cellar: :any,                 arm64_sonoma:  "4b2634705c772c330aa357244a907314b3d309e7b119193498ca04e25d43024b"
    sha256 cellar: :any,                 sonoma:        "82bc0d06d59ce7f296b1876fdb59a327ebb3d8de97807171989e37c7886368d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e4c65e095db9d22d61935bb77487b19682f5ca771067a203589187a463a952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9487e993a5fe4edb8b5a9fbcc97306171167b682e13828c72abb4f53ce01b2f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
