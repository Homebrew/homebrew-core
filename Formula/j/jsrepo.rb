class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.2.tgz"
  sha256 "cb48a4f074c11c95618150f3e27b43dcdb2f6bfabf65a38075021d40e6a7edd4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2249b7c538846b9f248f0ff6e3025470629a25809ad9d596f345e45ab14cad77"
    sha256 cellar: :any,                 arm64_sonoma:  "2249b7c538846b9f248f0ff6e3025470629a25809ad9d596f345e45ab14cad77"
    sha256 cellar: :any,                 arm64_ventura: "2249b7c538846b9f248f0ff6e3025470629a25809ad9d596f345e45ab14cad77"
    sha256 cellar: :any,                 sonoma:        "0e9cd7d9521894d382abdd663f43d321831395fcf38d567d58f5bae6b70ded85"
    sha256 cellar: :any,                 ventura:       "0e9cd7d9521894d382abdd663f43d321831395fcf38d567d58f5bae6b70ded85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9d133046eeffd2c34af38db6ad08f9e589f31a68f478791c4e20e7294776c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf4dc44ea9cec86bf7a5ae3a42b7247e46b466fb65e2f032912df384b327fba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
