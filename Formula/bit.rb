require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.1.1.tgz"
  sha256 "2d8f674a47b0f44f043a4865c90ba9eca41dff79e3742a2a3de5c244350147d4"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "125bbd3f6b13b4ca89aaec49b53cf154b9073a6b0bb760f0039d1c281fe4786c" => :mojave
    sha256 "14e4ef32cc67a6ed3254b2abea1b8b38d1179f3ce0057184bce90845b2e45932" => :high_sierra
    sha256 "22abd49020c104f268975b959c47f41dd85986cb74bb3ea66bfb3c93d95117b9" => :sierra
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
