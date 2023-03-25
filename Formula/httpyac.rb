require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.3.3.tgz"
  sha256 "b58e0e611472000c519f24943c23f15076cb2efba7455ce4f068fdf25ee60dd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d283d0dea10b933b9059895f503220a654951d7fb79ef1b3a1358d9f822bc1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d283d0dea10b933b9059895f503220a654951d7fb79ef1b3a1358d9f822bc1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d283d0dea10b933b9059895f503220a654951d7fb79ef1b3a1358d9f822bc1d"
    sha256 cellar: :any_skip_relocation, ventura:        "9d287b3f0751c9859c7b1977f54a816d6c1f61bba9a0e24fc2210a00e989b4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9d287b3f0751c9859c7b1977f54a816d6c1f61bba9a0e24fc2210a00e989b4b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d287b3f0751c9859c7b1977f54a816d6c1f61bba9a0e24fc2210a00e989b4b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1de05b8ad633b7355fc6dc7424ff8ead71afd40d6279da65b31ecf60441a695"
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
