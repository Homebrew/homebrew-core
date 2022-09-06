require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.7.0.tgz"
  sha256 "217ba047febfbafa88a34ecb031a7aea1ce3fb87bc46c43f802ff6f613a13d50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd7d077d82a3753cd37740715674551eca2a9a1172247da928528ef5ed3c0727"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd7d077d82a3753cd37740715674551eca2a9a1172247da928528ef5ed3c0727"
    sha256 cellar: :any_skip_relocation, monterey:       "113bf27a5cca6efbb57f7c2c50ab6ffb73e72e3e79246f8b52ac58522207c7b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "113bf27a5cca6efbb57f7c2c50ab6ffb73e72e3e79246f8b52ac58522207c7b8"
    sha256 cellar: :any_skip_relocation, catalina:       "113bf27a5cca6efbb57f7c2c50ab6ffb73e72e3e79246f8b52ac58522207c7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9801f18f996cdbde43be903c57741252740949b427cebbf46af837c4e91cd837"
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
