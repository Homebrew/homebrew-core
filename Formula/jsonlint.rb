require "language/node"

class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://github.com/zaach/jsonlint/archive/v1.6.0.tar.gz"
  sha256 "a7f763575d3e3ecc9b2a24b18ccbad2b4b38154c073ac63ebc9517c4cb2de06f"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write('{"name": "test"}')
    system "#{bin}/jsonlint", "test.json"
  end
end
