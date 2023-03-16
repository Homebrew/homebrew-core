require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.3.1.tgz"
  sha256 "9026d4f50abb7fc85509c5d1b7266c60b4dff2879be1a00b9df9a7b8254016df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83380bf4ae6b475f29d64f898f1b7935cad9409abb4973460fab4f95b0256778"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83380bf4ae6b475f29d64f898f1b7935cad9409abb4973460fab4f95b0256778"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83380bf4ae6b475f29d64f898f1b7935cad9409abb4973460fab4f95b0256778"
    sha256 cellar: :any_skip_relocation, ventura:        "209b57bb12b5a6d30bced6025f7a35b0e95c081685d472d815b8e627abff647c"
    sha256 cellar: :any_skip_relocation, monterey:       "209b57bb12b5a6d30bced6025f7a35b0e95c081685d472d815b8e627abff647c"
    sha256 cellar: :any_skip_relocation, big_sur:        "209b57bb12b5a6d30bced6025f7a35b0e95c081685d472d815b8e627abff647c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e8478eb7c506303372d8c3a8f6978901d91565603ce987a404ad97703a9496"
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
