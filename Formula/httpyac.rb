require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.4.1.tgz"
  sha256 "1007173e662304853e79221f925603aa9794bdf4aa5927d049dc947113dd9449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e96895eebb423aa65719052c01c2b6f0e08d78a28a1234b1f6d5ee8409e16b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e96895eebb423aa65719052c01c2b6f0e08d78a28a1234b1f6d5ee8409e16b"
    sha256 cellar: :any_skip_relocation, monterey:       "a40769e48ab695d713882c1ac152c5d967257a2cd4027a11296aeaec20805e77"
    sha256 cellar: :any_skip_relocation, big_sur:        "a40769e48ab695d713882c1ac152c5d967257a2cd4027a11296aeaec20805e77"
    sha256 cellar: :any_skip_relocation, catalina:       "a40769e48ab695d713882c1ac152c5d967257a2cd4027a11296aeaec20805e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6668ea8ef22e75c45a776b5d527d183838730df61f212ddff9078eccd0c4aa26"
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
