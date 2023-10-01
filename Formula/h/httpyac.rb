require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.7.tgz"
  sha256 "6d8847736b44e71fad37b442563a7ec07ff62a523dee54ea6c8494b7919fc9e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d546524e485ad21e9be6a75594c4abf2f7eecfcecbd64f35d459022093ca0ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d546524e485ad21e9be6a75594c4abf2f7eecfcecbd64f35d459022093ca0ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d546524e485ad21e9be6a75594c4abf2f7eecfcecbd64f35d459022093ca0ab"
    sha256 cellar: :any_skip_relocation, ventura:        "78abb3e94c6a0c7413d1e1cb72118c2c3804d94595e7dc3a906364d6db746b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "78abb3e94c6a0c7413d1e1cb72118c2c3804d94595e7dc3a906364d6db746b4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "78abb3e94c6a0c7413d1e1cb72118c2c3804d94595e7dc3a906364d6db746b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464060308f6ffd4c40dfc758757df9e8a3500b3cea04663d26588c900d02e58b"
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
