require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.2.3.tgz"
  sha256 "b21c0f2dd4196eff73398c1619849b0c46ca51adb6d72b179b78e06a3eb72aa9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32b48aec1fb46467349b12f7330b2be84c626442fc84c51422026bb013b630cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2b0ff57bf37306d4b826dfaeb0492f21ff967602ce613590a6fa50996dda84a"
    sha256 cellar: :any_skip_relocation, catalina:      "e2b0ff57bf37306d4b826dfaeb0492f21ff967602ce613590a6fa50996dda84a"
    sha256 cellar: :any_skip_relocation, mojave:        "e2b0ff57bf37306d4b826dfaeb0492f21ff967602ce613590a6fa50996dda84a"
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

    assert_match "newman", shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
