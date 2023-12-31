require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.1.0.tgz"
  sha256 "84994adb6cabbfa26da5d9a20e2b45d3199135f3047f280304e4e54abdc2d494"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f913cec384870fed53812e1923b5f0fab7a60f6ba0c87e8c252aa5567401ee0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f913cec384870fed53812e1923b5f0fab7a60f6ba0c87e8c252aa5567401ee0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f913cec384870fed53812e1923b5f0fab7a60f6ba0c87e8c252aa5567401ee0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "61ea4d727e02e8989a393071b4e7871ddd115b385041cd17018619af6eac15ef"
    sha256 cellar: :any_skip_relocation, ventura:        "61ea4d727e02e8989a393071b4e7871ddd115b385041cd17018619af6eac15ef"
    sha256 cellar: :any_skip_relocation, monterey:       "61ea4d727e02e8989a393071b4e7871ddd115b385041cd17018619af6eac15ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f913cec384870fed53812e1923b5f0fab7a60f6ba0c87e8c252aa5567401ee0a"
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
