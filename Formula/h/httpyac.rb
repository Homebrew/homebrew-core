require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.6.4.tgz"
  sha256 "40f2a8090c39eba5968768a50df1ccb07cce3826fab042a873ed96e37e7f3f79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bbaf5e1b77e78c8f5e8e54d76d3c76dce749a796e3c714362517cabbc547c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bbaf5e1b77e78c8f5e8e54d76d3c76dce749a796e3c714362517cabbc547c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bbaf5e1b77e78c8f5e8e54d76d3c76dce749a796e3c714362517cabbc547c69"
    sha256 cellar: :any_skip_relocation, ventura:        "9b4d8d697108c41bc4b900e4ede6947f95555736515794ec2fea93a811ca5416"
    sha256 cellar: :any_skip_relocation, monterey:       "9b4d8d697108c41bc4b900e4ede6947f95555736515794ec2fea93a811ca5416"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b4d8d697108c41bc4b900e4ede6947f95555736515794ec2fea93a811ca5416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24eb894c4b32fbfd9a55d24cf956d4be208381d9871c4772b21cca6dd1fb7584"
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
