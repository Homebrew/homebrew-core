class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.16.4.tgz"
  sha256 "2139537b6f368a0fa749e881773c71886022ced16bbd4dcf1d795c276c6441d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37eb0fc1a66cd6b3a77188fd9f254cb1494bef9d721a22d611e173a3b15d52a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37eb0fc1a66cd6b3a77188fd9f254cb1494bef9d721a22d611e173a3b15d52a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37eb0fc1a66cd6b3a77188fd9f254cb1494bef9d721a22d611e173a3b15d52a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b1b87abf924b622a3974dc570361f608529b750df4c87dc0a9059b63862f549"
    sha256 cellar: :any_skip_relocation, ventura:       "3b1b87abf924b622a3974dc570361f608529b750df4c87dc0a9059b63862f549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f73fd6c0b7ed96685867fbfbc8886953e646dc2449a3f1e328e73b1b3d7326"
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
