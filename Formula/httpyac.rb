require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.3.2.tgz"
  sha256 "eba0298fada2ee5d4c6cec03afa0583a96bf69c8c171e78c293904cc9f13130d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc28e4924b8c691cf90f7320ea379c865ab21e4adb56ac15855d262113b333db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc28e4924b8c691cf90f7320ea379c865ab21e4adb56ac15855d262113b333db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc28e4924b8c691cf90f7320ea379c865ab21e4adb56ac15855d262113b333db"
    sha256 cellar: :any_skip_relocation, ventura:        "5fcb3799a7cd2dc3cbdb073a7b812f487461a496e23b641e88ec32736c9f3866"
    sha256 cellar: :any_skip_relocation, monterey:       "5fcb3799a7cd2dc3cbdb073a7b812f487461a496e23b641e88ec32736c9f3866"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fcb3799a7cd2dc3cbdb073a7b812f487461a496e23b641e88ec32736c9f3866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5015faaad23c9176879498b0d6a62096e7b639b172afd34b4ce391a4baf2b29"
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
