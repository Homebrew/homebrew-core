require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.6.4.tgz"
  sha256 "0f474112e40f83718234cbee9bb638536c5a3e77eec5ad4df25b919b5c525143"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a94f4029180ee404001d8a1fe512f52708880a9a1ff76e3c4dff1dd87d381002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a94f4029180ee404001d8a1fe512f52708880a9a1ff76e3c4dff1dd87d381002"
    sha256 cellar: :any_skip_relocation, monterey:       "34c259c71a873492ebffcce9ff8979a7441478a72727dce8d5840411c7c75981"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c259c71a873492ebffcce9ff8979a7441478a72727dce8d5840411c7c75981"
    sha256 cellar: :any_skip_relocation, catalina:       "34c259c71a873492ebffcce9ff8979a7441478a72727dce8d5840411c7c75981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc0cdda44dc6a58e444c417600c08089abcafa4e5cedd2d0bc3c78a44c9426d3"
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
