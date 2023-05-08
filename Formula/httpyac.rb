require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.4.2.tgz"
  sha256 "ecb4f6b677cba1ae1215cd0cdf7f1b45455cd88ce81d847e00603f8714bb127d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cfa63928321f02f6a9fd23792b3e6b65af4f3c3c78a4350f79fa5c0113f910c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cfa63928321f02f6a9fd23792b3e6b65af4f3c3c78a4350f79fa5c0113f910c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cfa63928321f02f6a9fd23792b3e6b65af4f3c3c78a4350f79fa5c0113f910c"
    sha256 cellar: :any_skip_relocation, ventura:        "b3decff1818d9ef2ef4f3574163f20c0c868bd232e6aa573abaaef1a7d1b10e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b3decff1818d9ef2ef4f3574163f20c0c868bd232e6aa573abaaef1a7d1b10e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3decff1818d9ef2ef4f3574163f20c0c868bd232e6aa573abaaef1a7d1b10e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07589962a1a78ba6efdd1503737f2e85e0f7a12ac615cdd0f3129f23dc2a202a"
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
