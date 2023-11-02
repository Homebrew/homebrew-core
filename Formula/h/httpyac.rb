require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.9.0.tgz"
  sha256 "c7bf3c9f8b78a2df55b19733e3c031af378dd8b65963969e1a1e6f8f0e3b1b79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0270f8598207db21e38694a4da0184ed3ed6afd4ad45167d9c6a24231cb529dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0270f8598207db21e38694a4da0184ed3ed6afd4ad45167d9c6a24231cb529dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0270f8598207db21e38694a4da0184ed3ed6afd4ad45167d9c6a24231cb529dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb77ffac0d663cef29b296d0bebd012e290793ee221408dada58ed785cf0d454"
    sha256 cellar: :any_skip_relocation, ventura:        "fb77ffac0d663cef29b296d0bebd012e290793ee221408dada58ed785cf0d454"
    sha256 cellar: :any_skip_relocation, monterey:       "fb77ffac0d663cef29b296d0bebd012e290793ee221408dada58ed785cf0d454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4374bcd28d529cf558b1be468820f59a4bd52d9ecbab34a7b9c2424e666b5e14"
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
