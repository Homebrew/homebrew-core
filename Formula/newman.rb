require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.0.0.tgz"
  sha256 "07a87547269ac02e0599ee098d836094785e2583215d058c60d812a5ff3ea5b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "9332df45737d2d6c87aa280d3cd0360d584dcb6d5060b9592af41087dd629043" => :catalina
    sha256 "fb70b86af8b6d7d026cd86f3823223abed62764cc1b2098beb321f9dc66ef3a7" => :mojave
    sha256 "68ff23d2eb2720b9ce95c3d7ee75ff1cacef22660c8e1ac5bbdf9b280777954e" => :high_sierra
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
