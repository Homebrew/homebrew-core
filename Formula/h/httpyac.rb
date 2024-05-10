require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.13.2.tgz"
  sha256 "60a8b83738d6fd4790463a6e518ad6f3d6fb4d786a34f1567c7357a051ce0db8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4f9e5d82ae285e8f48991a75b475888ad686161b9c921afe758d04453262a6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4f9e5d82ae285e8f48991a75b475888ad686161b9c921afe758d04453262a6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f9e5d82ae285e8f48991a75b475888ad686161b9c921afe758d04453262a6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed2d186c807c3736c9f754b9e76bce409af4fbda252138d1cc2ca2d0cee8768c"
    sha256 cellar: :any_skip_relocation, ventura:        "ed2d186c807c3736c9f754b9e76bce409af4fbda252138d1cc2ca2d0cee8768c"
    sha256 cellar: :any_skip_relocation, monterey:       "ed2d186c807c3736c9f754b9e76bce409af4fbda252138d1cc2ca2d0cee8768c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a124968d630d2aed8777f1cd6b748b2aa95215dd647cd5015a64118024a82b20"
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
