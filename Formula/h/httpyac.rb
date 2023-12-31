require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.11.0.tgz"
  sha256 "47bf6b7074891402c9e4df15137d69062867dafd3abbf635c65d7dd8736b0027"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edef0b9900ccc123f0f170d2cdb8eb927d571f9a1b36a8adad695e5373305221"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edef0b9900ccc123f0f170d2cdb8eb927d571f9a1b36a8adad695e5373305221"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edef0b9900ccc123f0f170d2cdb8eb927d571f9a1b36a8adad695e5373305221"
    sha256 cellar: :any_skip_relocation, sonoma:         "801f68009ce559f28a2ee9fd35c6ae721b85f21bf8c98d0a69f79597a6ff7918"
    sha256 cellar: :any_skip_relocation, ventura:        "801f68009ce559f28a2ee9fd35c6ae721b85f21bf8c98d0a69f79597a6ff7918"
    sha256 cellar: :any_skip_relocation, monterey:       "801f68009ce559f28a2ee9fd35c6ae721b85f21bf8c98d0a69f79597a6ff7918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "388a0b3d994e7d34e6b400afcc5ea0c660435e5233e07d95fad9bafb8700e757"
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
