require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.2.0.tgz"
  sha256 "524f72279edd8fdbdfc37c425f9f094ef15fade057797b8bd51d147252436c66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9250885abdb0f36acb18e186241f12916c79c472d953b26205bf23f5b00f1482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9250885abdb0f36acb18e186241f12916c79c472d953b26205bf23f5b00f1482"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9250885abdb0f36acb18e186241f12916c79c472d953b26205bf23f5b00f1482"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd9d1cf142122d63f8a1b8b59a7f0ef99a9130761ea97a5862a3d696a77aebe"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd9d1cf142122d63f8a1b8b59a7f0ef99a9130761ea97a5862a3d696a77aebe"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fd9d1cf142122d63f8a1b8b59a7f0ef99a9130761ea97a5862a3d696a77aebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7183331dc075540c19ccd738e5fc8a192ac08bacabc415b496140a2fe349f2ab"
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
