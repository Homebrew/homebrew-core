require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "http://alexjs.com"
  url "https://github.com/wooorm/alex/archive/4.0.1.tar.gz"
  sha256 "85786f7e5a89b2ee77c54a57275723046309933639f96ab3174e9366c7c37675"

  bottle do
    cellar :any_skip_relocation
    sha256 "77742bd766ced4b5b967ae4e67fc90282757be55bb039aebaf3f6a69ddc0a53f" => :sierra
    sha256 "b3fefe37d5abcafd84685c816bb4a6a8ad02ae2ad87f0d6c2692295c9c4a727a" => :el_capitan
    sha256 "40aa9a3a1310165657ae47476c7593a08a7dbc90d133f1688505c9e7973144f0" => :yosemite
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
