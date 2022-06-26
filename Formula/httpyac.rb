require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.5.1.tgz"
  sha256 "2da599657e711722d395834c5d828591a91c08e8abc0fa62a177f1511fb0afa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ccd13db8526cc85f8f27c418d96a899d6d4093bfc2fa67d73a8d140bc6c62d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6ccd13db8526cc85f8f27c418d96a899d6d4093bfc2fa67d73a8d140bc6c62d"
    sha256 cellar: :any_skip_relocation, monterey:       "858d31792d92923b5bcf5fb40cf812e51fb21cdb7746fdfa86f37214498c7308"
    sha256 cellar: :any_skip_relocation, big_sur:        "858d31792d92923b5bcf5fb40cf812e51fb21cdb7746fdfa86f37214498c7308"
    sha256 cellar: :any_skip_relocation, catalina:       "858d31792d92923b5bcf5fb40cf812e51fb21cdb7746fdfa86f37214498c7308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63aa0eaa40a0fafa74b3502d9ea5777f5fe1a04bad3c8c0e5b678dc9980a1a18"
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
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
