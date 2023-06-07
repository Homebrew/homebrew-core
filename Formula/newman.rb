require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.3.2.tgz"
  sha256 "02f4468076e38b8950281518839cc3869f4c5b7ad7cab34e9e600c1451e2fcd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de2ca1eb34c63680808d9cf35b85016e0e8652e0f6063f0988a55c5301936360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffbd3ef5d1bf69b22eb175f6d72599c4d915d1b1fdea6dfd7a7f85fff4d4f6c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffbd3ef5d1bf69b22eb175f6d72599c4d915d1b1fdea6dfd7a7f85fff4d4f6c9"
    sha256 cellar: :any_skip_relocation, ventura:        "4ff9a735ef2468472da211930c8ba7425513af5c909a040ef49ce8f686fbbe88"
    sha256 cellar: :any_skip_relocation, monterey:       "f9458d98ebca55f9aac434fcb5e65d6ef5327d0de50f1da8945e165820d4f5f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "af2c026502794cf7b25fcd468ee2b7769fc62c081c6946b6bb96a983f50dc978"
    sha256 cellar: :any_skip_relocation, catalina:       "af2c026502794cf7b25fcd468ee2b7769fc62c081c6946b6bb96a983f50dc978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbd3ef5d1bf69b22eb175f6d72599c4d915d1b1fdea6dfd7a7f85fff4d4f6c9"
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
