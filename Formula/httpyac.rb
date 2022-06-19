require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.5.0.tgz"
  sha256 "76a03c480998a4bbb4fb42954fdca45ba3f337ea007ccd2c8f7aea780cd8be06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "983798520581a6721c61ad22bcfaae138856d8c461f99d22603430fef9b0ab90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "983798520581a6721c61ad22bcfaae138856d8c461f99d22603430fef9b0ab90"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe05d99c31176698b1fc933c63f34f0c8de900d17b23e1be2dda14d2fd00829"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe05d99c31176698b1fc933c63f34f0c8de900d17b23e1be2dda14d2fd00829"
    sha256 cellar: :any_skip_relocation, catalina:       "8fe05d99c31176698b1fc933c63f34f0c8de900d17b23e1be2dda14d2fd00829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b12e1bfe51f7442e609e3a3bcbdc544a3e875a822884edc358691c45fa6f9a"
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
