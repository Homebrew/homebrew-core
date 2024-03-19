require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.12.0.tgz"
  sha256 "f3858f02826a76eb8f084a3c019f7203a8f2f1bc146f618ed8b6e7950c3829d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e32c9e05a76335c9404d8b14d2462cf3dc75bdac8419b6f9b0dba6e59556ff7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e32c9e05a76335c9404d8b14d2462cf3dc75bdac8419b6f9b0dba6e59556ff7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32c9e05a76335c9404d8b14d2462cf3dc75bdac8419b6f9b0dba6e59556ff7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e6faed835d7acca8b26fe5e8832b9c1de54c759506cb82cd56487bff175b16b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6faed835d7acca8b26fe5e8832b9c1de54c759506cb82cd56487bff175b16b"
    sha256 cellar: :any_skip_relocation, monterey:       "5e6faed835d7acca8b26fe5e8832b9c1de54c759506cb82cd56487bff175b16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96e302bcd934393b826e79f8bb5179d519fa987b53172b45d57f67ebae3a53c"
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
