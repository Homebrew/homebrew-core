require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.6.0.tgz"
  sha256 "7341ecf1625adde3dbacc1e668e9b199b309fe05805f6b5a03f5a4d4e6f0ba0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cd5e0ff3f0f49030e468528d3e28761765356829c3ce04eb2202791f17864f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cd5e0ff3f0f49030e468528d3e28761765356829c3ce04eb2202791f17864f4"
    sha256 cellar: :any_skip_relocation, monterey:       "47ffa1596f74e885c55e99e8f1be9086112ddc4040bf611e6b37b3fd8b8e69b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "47ffa1596f74e885c55e99e8f1be9086112ddc4040bf611e6b37b3fd8b8e69b9"
    sha256 cellar: :any_skip_relocation, catalina:       "47ffa1596f74e885c55e99e8f1be9086112ddc4040bf611e6b37b3fd8b8e69b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15a57af21b632e7edf822720387615d9c01e0e0c0ca9bac509db05c2b8c39d8"
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
