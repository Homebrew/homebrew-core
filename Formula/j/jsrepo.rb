class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.45.1.tgz"
  sha256 "eb5b217996256b0bb705ec735a019f6392a13d5196f4387ae0f5fed044914504"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "851e3d0b3c9e24dc96e875c2449ddad5c130194945a4d59cb87ee127f8c2b2a1"
    sha256 cellar: :any,                 arm64_sonoma:  "851e3d0b3c9e24dc96e875c2449ddad5c130194945a4d59cb87ee127f8c2b2a1"
    sha256 cellar: :any,                 arm64_ventura: "851e3d0b3c9e24dc96e875c2449ddad5c130194945a4d59cb87ee127f8c2b2a1"
    sha256 cellar: :any,                 sonoma:        "d53873767ad0228a6c76d120fc92767dd375d022491c9db49fce276a5df296fb"
    sha256 cellar: :any,                 ventura:       "d53873767ad0228a6c76d120fc92767dd375d022491c9db49fce276a5df296fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9850b8008468f5475b2da08aa0f7939ea457fcc93e086ef392e7e9c7a4cfefb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea7c16f06e20a6d32f7a1a2b8755b0437f64afd5067773789262962f00f92a29"
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
