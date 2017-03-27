require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "http://alexjs.com"
  url "https://github.com/wooorm/alex/archive/4.0.1.tar.gz"
  sha256 "85786f7e5a89b2ee77c54a57275723046309933639f96ab3174e9366c7c37675"

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
