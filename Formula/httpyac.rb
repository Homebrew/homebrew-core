require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.4.5.tgz"
  sha256 "c93d8916b63e0812f413761b7bd62c9f4a9e93cdfcf5751ef58ccf00d08517a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcd1f27b69305690f3a09289d398283af86478f5a899eadabc4487949d8d1605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcd1f27b69305690f3a09289d398283af86478f5a899eadabc4487949d8d1605"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcd1f27b69305690f3a09289d398283af86478f5a899eadabc4487949d8d1605"
    sha256 cellar: :any_skip_relocation, ventura:        "8c6045cee596a997cfbadb29910065c95a3da6731aa056cfcddd0969fd3ef18b"
    sha256 cellar: :any_skip_relocation, monterey:       "8c6045cee596a997cfbadb29910065c95a3da6731aa056cfcddd0969fd3ef18b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c6045cee596a997cfbadb29910065c95a3da6731aa056cfcddd0969fd3ef18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77e3cfb0e4956438ede404419cf1d1139757cc52df2aa9d765227e66966c1911"
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
