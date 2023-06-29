require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.5.1.tgz"
  sha256 "68c831c1bc5aa0940de2e47ae71c8ebd35e4c764f6e8860dc59483cd3c4e51a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66766c8d4831d090d0e3bdc107b3244d9df957c9b23e0383f138a87bcecd54bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66766c8d4831d090d0e3bdc107b3244d9df957c9b23e0383f138a87bcecd54bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66766c8d4831d090d0e3bdc107b3244d9df957c9b23e0383f138a87bcecd54bf"
    sha256 cellar: :any_skip_relocation, ventura:        "2a3aa1f0423d5fc20d2ec0bfa51ba21cef0db80473d81aa113a9e92bb5a43ace"
    sha256 cellar: :any_skip_relocation, monterey:       "2a3aa1f0423d5fc20d2ec0bfa51ba21cef0db80473d81aa113a9e92bb5a43ace"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a3aa1f0423d5fc20d2ec0bfa51ba21cef0db80473d81aa113a9e92bb5a43ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1659b82a3e0414d6606fa5b33e507e027da3c79a80ac2a780478f492a4cfbc"
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
