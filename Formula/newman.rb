require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-4.6.0.tgz"
  sha256 "439c2e6c6d4c14623b03d21c4807efdf42af2e58f36a25dbfac06729b30298aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ffd375dd0b12f8a26ddc0fbaa82f726c941b3b0259af0f42451a3659d58736b" => :catalina
    sha256 "4f7b77612a5d1da5a28a6f6338edf74e4bbe7f6fccb48cbf99e53ae569dbd98a" => :mojave
    sha256 "2c85b9a8570716ed45f07689d39b074bebb79d6fab6964d927cdfb308dcbfce7" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    path = testpath/"test-collection.json"
    path.write <<~EOS
      {
        "info": {
          "_postman_id": "db95eac2-6e1c-48c0-8c3a-f83c5341d4dd",
          "name": "Homebrew",
          "description": "Homebrew formula test",
          "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        "item": [
          {
            "name": "httpbin-get",
            "request": {
              "method": "GET",
              "header": [],
              "body": {
                "mode": "raw",
                "raw": ""
              },
              "url": {
                "raw": "https://httpbin.org/get",
                "protocol": "https",
                "host": [
                  "httpbin",
                  "org"
                ],
                "path": [
                  "get"
                ]
              }
            },
            "response": []
          }
        ]
      }
    EOS

    assert_match /newman/, shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
