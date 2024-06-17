require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.14.0.tgz"
  sha256 "5beb938d2def06b639290493f8d975e96aa9619a7f04f6ce51e98c7c538c7402"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e46d3bea588bb7078209fbbb94f88c83c4041d7a7af6f389325201f07e1f57dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e46d3bea588bb7078209fbbb94f88c83c4041d7a7af6f389325201f07e1f57dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46d3bea588bb7078209fbbb94f88c83c4041d7a7af6f389325201f07e1f57dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "21ae5e623fdb380d94554910e60aae595c4a2bc94276355be50d2198ddae919c"
    sha256 cellar: :any_skip_relocation, ventura:        "21ae5e623fdb380d94554910e60aae595c4a2bc94276355be50d2198ddae919c"
    sha256 cellar: :any_skip_relocation, monterey:       "21ae5e623fdb380d94554910e60aae595c4a2bc94276355be50d2198ddae919c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379b95b110ca0ffa349bfe8d0ea9644714a3d1abdfcde9adc4cf4928fee7141d"
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
