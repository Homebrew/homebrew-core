require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.1.3.tgz"
  sha256 "9358f14b52fe8c835a27557a98e9ec9df2df5cacf286195b4ccbebdaccb1e942"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc6f8a704e46ca38d99f0d8d980f910dd6ad9f3d8c0b9e23b3abf29b452e1dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecc6f8a704e46ca38d99f0d8d980f910dd6ad9f3d8c0b9e23b3abf29b452e1dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc6f8a704e46ca38d99f0d8d980f910dd6ad9f3d8c0b9e23b3abf29b452e1dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fa16f67b6cce040a5048f7247833b663d31da026eb327c702e795324bc610be"
    sha256 cellar: :any_skip_relocation, ventura:        "1fa16f67b6cce040a5048f7247833b663d31da026eb327c702e795324bc610be"
    sha256 cellar: :any_skip_relocation, monterey:       "1fa16f67b6cce040a5048f7247833b663d31da026eb327c702e795324bc610be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667de2f36c865416e3a585c619fbb2274588fff370e644e4748bfd97b24ada73"
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
