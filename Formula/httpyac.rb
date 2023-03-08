require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.2.1.tgz"
  sha256 "311843c42cae083a99df7621fd82a03f1e6ccf9a2e30c71513eaf7c333b92c01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "356f11df5652d77d3752a944f9cbc08447d54abd2c359b00235e825b6aea7711"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356f11df5652d77d3752a944f9cbc08447d54abd2c359b00235e825b6aea7711"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356f11df5652d77d3752a944f9cbc08447d54abd2c359b00235e825b6aea7711"
    sha256 cellar: :any_skip_relocation, ventura:        "8b29aee34cf6dc0a98f7ab582c9d8abe5becd5f4c129304c4e0f2b70abf800af"
    sha256 cellar: :any_skip_relocation, monterey:       "8b29aee34cf6dc0a98f7ab582c9d8abe5becd5f4c129304c4e0f2b70abf800af"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b29aee34cf6dc0a98f7ab582c9d8abe5becd5f4c129304c4e0f2b70abf800af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fb10b59bc543a309bde12dd824b121ff41f62a1581909aece14d50a5ac15453"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"test_cases").write <<~EOS
      GET https://httpbin.org/anything HTTP/1.1
      Content-Type: text/html
      Authorization: Bearer token

      POST https://countries.trevorblades.com/graphql
      Content-Type: application/json

      query Continents($code: String!) {
          continents(filter: {code: {eq: $code}}) {
            code
            name
          }
      }

      {
          "code": "EU"
      }
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for graphql call
    assert_match "\"name\": \"Europe\"", output
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
