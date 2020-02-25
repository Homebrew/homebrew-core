require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-4.6.0.tgz"
  sha256 "439c2e6c6d4c14623b03d21c4807efdf42af2e58f36a25dbfac06729b30298aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "79e19d1d9dce22e42cf7586f06c789877bb78bb3df1c7af6a6c33ce5ff1d40db" => :catalina
    sha256 "a3974f24f110660676c23ce34238f957c1eb85d9f8ae7a67b3b7bdd3a485ccef" => :mojave
    sha256 "bda360d848a4017f2b2ef81a37e364297a84a5c3d2a7cc1e1d6df2e423497b4f" => :high_sierra
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
