require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.110.tgz"
  sha256 "d48393e5bdbaf8a7a59b37774b6630c0be0ed6e5ed98d572d65cea2a28fff55f"

  bottle do
    sha256 "374de8e2ecc5bc82bb1cc0d03d618051c6f561b0bce83fd2aaf7b4eaa19a3773" => :high_sierra
    sha256 "85d88d8d739fa4dd567221b7962fa84cd843a9029d7c84188d275da078ce58da" => :sierra
    sha256 "5b597c30f3c5f471b8b4768e4c1250c364a84439bb48139ed4c5ed38183fbd04" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
