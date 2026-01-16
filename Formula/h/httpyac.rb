class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.7.tgz"
  sha256 "e6bc615ef8b58ea9334fcac3e2000eb3e49926dca1ec7087456e9aa6c402000e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9385fc282fdff9c2b672ca82bad9ae9f9c6de9057de7f85afc4beaf599e1d3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c661e19ffede29528d8ac52646f9453c17bced8e814b33fc3c078092d28a434e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c661e19ffede29528d8ac52646f9453c17bced8e814b33fc3c078092d28a434e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c661e19ffede29528d8ac52646f9453c17bced8e814b33fc3c078092d28a434e"
    sha256 cellar: :any_skip_relocation, sonoma:        "866418e856e92498dfcc3efd3f1418a5db7791e0addce76c733a9af8f74064a8"
    sha256 cellar: :any_skip_relocation, ventura:       "866418e856e92498dfcc3efd3f1418a5db7791e0addce76c733a9af8f74064a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db1182a2c0a29553eefb6f3477fcfdbbf5a769a954520ac2ddd8bfe07355cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db1182a2c0a29553eefb6f3477fcfdbbf5a769a954520ac2ddd8bfe07355cc5"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
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
    assert_match "2 requests processed (2 succeeded)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
