require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.2.3.tgz"
  sha256 "5d5d67a6dc4cdf67415b29f6999174f5138f7e4fc4bca81e4ca0144ff3052782"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2fd4455b1f48333696759cfe3689c8becee20abdb9b2c37a696ec3e640cd84d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2fd4455b1f48333696759cfe3689c8becee20abdb9b2c37a696ec3e640cd84d"
    sha256 cellar: :any_skip_relocation, monterey:       "41cb4d68692c7fb704d67d6f271c0a133097d884f112e1e267409b0a346b2e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "41cb4d68692c7fb704d67d6f271c0a133097d884f112e1e267409b0a346b2e39"
    sha256 cellar: :any_skip_relocation, catalina:       "41cb4d68692c7fb704d67d6f271c0a133097d884f112e1e267409b0a346b2e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fdc7a7a16d9b7f595874c34b6d2ac6b08c9a31bf6803639be4df25ca108bacc"
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

      # @keepStreaming
      MQTT tcp://broker.hivemq.com
      Topic: testtopic/1
      Topic: testtopic/2
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for mqtt calls
    assert_match "testtopic/2:  Check with Mazin", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
