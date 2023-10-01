require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.0.0.tgz"
  sha256 "ff6632442fe30a9792ad2462286e83bdcf69f267a44c9f731b43f6beb5141b11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1197a724d5922758bf56896954645a500033e606860cc53669ea4826a28c8ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1197a724d5922758bf56896954645a500033e606860cc53669ea4826a28c8ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1197a724d5922758bf56896954645a500033e606860cc53669ea4826a28c8ca6"
    sha256 cellar: :any_skip_relocation, ventura:        "dca54fa835336bf6380cfeaa99f47205f3ee3a9eb7e27384da897d46688f3270"
    sha256 cellar: :any_skip_relocation, monterey:       "dca54fa835336bf6380cfeaa99f47205f3ee3a9eb7e27384da897d46688f3270"
    sha256 cellar: :any_skip_relocation, big_sur:        "568a7dcd98ea876e31eb4ad0aa7edf47c8f34c3a4324f23d8ec8584caf718a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1197a724d5922758bf56896954645a500033e606860cc53669ea4826a28c8ca6"
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
