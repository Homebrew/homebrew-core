class Jprot < Formula
  desc "Portfolio site generator without a build step"
  homepage "https://github.com/Moaaz-i/JPROT"
  url "https://registry.npmjs.org/jprot/-/jprot-0.9.1.tgz"
  sha256 "6f013e32261e17ca3c0d6fe736343ae1ac668fae1422c94606d82bd91f485f2a"
  license "MIT"
  head "https://github.com/Moaaz-i/JPROT", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"jprot", "--version"
  end
end
