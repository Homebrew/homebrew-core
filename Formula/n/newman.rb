require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.1.2.tgz"
  sha256 "364b9e73156c18ceb1884327d38bb5b3192ef9291712a604496ffca738744d00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f090e47d6972f0a4871c6bb4a60ab94c7cc6a5f3e5ae8c00d10c9140a0ef6c60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f090e47d6972f0a4871c6bb4a60ab94c7cc6a5f3e5ae8c00d10c9140a0ef6c60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f090e47d6972f0a4871c6bb4a60ab94c7cc6a5f3e5ae8c00d10c9140a0ef6c60"
    sha256 cellar: :any_skip_relocation, sonoma:         "19c30b0dfa57c803d0b84d61f2322e8e5971f325e86ce9776b01370147729c90"
    sha256 cellar: :any_skip_relocation, ventura:        "19c30b0dfa57c803d0b84d61f2322e8e5971f325e86ce9776b01370147729c90"
    sha256 cellar: :any_skip_relocation, monterey:       "19c30b0dfa57c803d0b84d61f2322e8e5971f325e86ce9776b01370147729c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f090e47d6972f0a4871c6bb4a60ab94c7cc6a5f3e5ae8c00d10c9140a0ef6c60"
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
