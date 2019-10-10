require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/8.0.0.tar.gz"
  sha256 "681022a4e5a03e15e4aa0a65b417929b1d7d8ce24f6805f90cf442e589d16269"

  bottle do
    cellar :any_skip_relocation
    sha256 "96cab203feebafc2e264fc1eab8ec081b140af9b18c652918ba7e6cdb1c9b0e3" => :mojave
    sha256 "d6c61237ef4dd720af9f39f209444646e826d1e6de95d309728dfb1765c5d718" => :high_sierra
    sha256 "62725013774c628ff03927c801ceb76b60cf45008f351e362ea42c4b4b639e9a" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
