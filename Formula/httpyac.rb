require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.4.4.tgz"
  sha256 "bff576342ac3028e97a64fd515aeb713250fd5358d6ee04c0523df76d2393717"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "134dbc2c5b07a4e54d3b9eb7fc8589ef765c6ca364b3de301e3f6f731bd65f3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "134dbc2c5b07a4e54d3b9eb7fc8589ef765c6ca364b3de301e3f6f731bd65f3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "134dbc2c5b07a4e54d3b9eb7fc8589ef765c6ca364b3de301e3f6f731bd65f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "4690485b4351f125b9aabf5c36415115735e60fe3de7fc34170abe5e00b890ae"
    sha256 cellar: :any_skip_relocation, monterey:       "4690485b4351f125b9aabf5c36415115735e60fe3de7fc34170abe5e00b890ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "4690485b4351f125b9aabf5c36415115735e60fe3de7fc34170abe5e00b890ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3b7d8acd484d5dcecaf0c27a461a05b9b7568ddc7eb76ff0247c2c276e7981"
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
