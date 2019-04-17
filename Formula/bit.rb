require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.0.6.tgz"
  sha256 "1f864892dd14726e82efc222a645c28cfd7e7b04b146d5ea6d1475b366dd43eb"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "a18f1b77453d40fe4477ff17ed482ca33b3d84017abcaeaea73084031874c8a2" => :mojave
    sha256 "aa51f1d9ec82a63c6d7c66c280f26a410db13dc9f220dca31f77efa141fb8b10" => :high_sierra
    sha256 "b20eacaa1df1fa2ad44c99276d32fc781fda630995d4153ec868d71aa72e8943" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
