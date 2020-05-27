require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.0.1.tgz"
  sha256 "e7c0667cc88a81d430450ac29b59ea425d344b66ebd3f722c518c3458b1fd5b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "692ee69c9b814c0b0d587b1ba9b8affd0a3353f406c20aac8f394d244268917c" => :catalina
    sha256 "33ead4b03db6491f5836012fb8520051c1624f9affd612a0401af1f15c7aa78b" => :mojave
    sha256 "f7e1747c60cf7dc969a9cd1b4b983d869982d71d082d89a4ce5dd77acdbc12e0" => :high_sierra
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
