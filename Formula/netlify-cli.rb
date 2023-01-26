require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.10.0.tgz"
  sha256 "5c3bffdfef42e652a711c6bb6bc6582944a6cdfbbeffc00a2f6069c36d7af59c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "5edf0d4bfad48a1814f7ff2ba25ddf5a32fbca023f5555396c5a2bc5d5d75845"
    sha256                               arm64_monterey: "836c804a37d85c38f8519068ee27bf13f683fae705998be0d7930b8db9bb97c7"
    sha256                               arm64_big_sur:  "2148a5ceec45b4c3185edcdbab73ed9b326890121f19fd31ed9a36fb6babb02d"
    sha256                               ventura:        "3d08ca23db73436958dfd9ccf609f78617ed84c374fb0b53587ca20bab9ffebd"
    sha256                               monterey:       "6725246b567b464f35ac2f8f5456bfd89f4e499ba73569d26456e293b9bd2545"
    sha256                               big_sur:        "c13d7cbe1e856a394cf3d12a03a94ababdb50bda7e11c8e592b10cd75b2fc3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed513c0e8804993a02e7ddfc38f63ee2cc16513cf3757af4510a335688d9719"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
