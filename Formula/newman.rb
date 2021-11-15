require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.3.0.tgz"
  sha256 "ea4bba024f2c67a18c26db376d25d07039f782a591f333f85774c33df992f378"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed8aefe21f414463cf04744841f68216c30aa55d1e3cff0177437d670c047ac0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4cdf08e832543aea81630dfd577e6547897b6782201253803528634d9197a74"
    sha256 cellar: :any_skip_relocation, monterey:       "0e441243ce409d13eaa6c7a3914fcfaf37d5f08ada406fb8dd71e2310d16167c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f025e48984e411788de3fa5678e4e70ffc84487d61fb37095ab17a498523e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b2f025e48984e411788de3fa5678e4e70ffc84487d61fb37095ab17a498523e0"
    sha256 cellar: :any_skip_relocation, mojave:         "b2f025e48984e411788de3fa5678e4e70ffc84487d61fb37095ab17a498523e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4cdf08e832543aea81630dfd577e6547897b6782201253803528634d9197a74"
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
