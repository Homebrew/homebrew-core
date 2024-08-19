class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.1.3.tgz"
  sha256 "9358f14b52fe8c835a27557a98e9ec9df2df5cacf286195b4ccbebdaccb1e942"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "083286f30003f41082fc28c1f840034fdbc439832df691616a74487b4ed115a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "083286f30003f41082fc28c1f840034fdbc439832df691616a74487b4ed115a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083286f30003f41082fc28c1f840034fdbc439832df691616a74487b4ed115a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "13f079c8ef75010ed011f0b421bfa8e499c70486d16fcde45546a3a1bdfd9f96"
    sha256 cellar: :any_skip_relocation, ventura:        "13f079c8ef75010ed011f0b421bfa8e499c70486d16fcde45546a3a1bdfd9f96"
    sha256 cellar: :any_skip_relocation, monterey:       "13f079c8ef75010ed011f0b421bfa8e499c70486d16fcde45546a3a1bdfd9f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7910178703776eabc29ef96cc2dd24a85f42803e0ce6cece7f54ee982d29e3b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
