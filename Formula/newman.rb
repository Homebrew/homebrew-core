require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.3.2.tgz"
  sha256 "02f4468076e38b8950281518839cc3869f4c5b7ad7cab34e9e600c1451e2fcd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3b7f441cf27651d0ed0dcd30ff3213a74cbb30cf7a2e108d53fd16df1783b9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b7f441cf27651d0ed0dcd30ff3213a74cbb30cf7a2e108d53fd16df1783b9a"
    sha256 cellar: :any_skip_relocation, monterey:       "c33c6d3fda315aa45cbff846f51913cd1fddb91f0d4881bec8df898b7270f79f"
    sha256 cellar: :any_skip_relocation, big_sur:        "90dfa8d17177c032691b65576180edc2bcabafb66f024ea7223bb0d3101dc339"
    sha256 cellar: :any_skip_relocation, catalina:       "90dfa8d17177c032691b65576180edc2bcabafb66f024ea7223bb0d3101dc339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b7f441cf27651d0ed0dcd30ff3213a74cbb30cf7a2e108d53fd16df1783b9a"
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
