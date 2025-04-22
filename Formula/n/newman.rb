class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.2.1.tgz"
  sha256 "38e457fafaadb7b4ff79f5669306bb8504223c4041cf5e5b6fc592f355af7a0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "572ef9f591942dec78b5810920a2cba00b28f5267f4d06e82e6ac942817e9683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa712cc0a93477ee5448241048937ca8ad4b9f4a21d19a29f30a359e4f4cb833"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa712cc0a93477ee5448241048937ca8ad4b9f4a21d19a29f30a359e4f4cb833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa712cc0a93477ee5448241048937ca8ad4b9f4a21d19a29f30a359e4f4cb833"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e795f5512a9fe59808b928884c3026a9ee5c2962053faef9f053d08214a1705"
    sha256 cellar: :any_skip_relocation, ventura:        "1e795f5512a9fe59808b928884c3026a9ee5c2962053faef9f053d08214a1705"
    sha256 cellar: :any_skip_relocation, monterey:       "1e795f5512a9fe59808b928884c3026a9ee5c2962053faef9f053d08214a1705"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "293d0a0e52c8d5c1e3ddebee286788baa6329839f4e664ee12240f7c80b28831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa712cc0a93477ee5448241048937ca8ad4b9f4a21d19a29f30a359e4f4cb833"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    path = testpath/"test-collection.json"
    path.write <<~JSON
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
    JSON

    assert_match "newman", shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
