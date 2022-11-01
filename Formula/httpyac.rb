require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.7.5.tgz"
  sha256 "5a03a009c46c506fd0a2d126252ad6f164f51674177d5cb8d3c3bb61c5c04edc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90a4812682a6335d51edb492ccdb600de89188d49db72014b0913e3e8f52e94d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90a4812682a6335d51edb492ccdb600de89188d49db72014b0913e3e8f52e94d"
    sha256 cellar: :any_skip_relocation, monterey:       "e447e280c38c6fb07b8a417db351175d90cfd5130d63784e9cd698cfc1e96108"
    sha256 cellar: :any_skip_relocation, big_sur:        "e447e280c38c6fb07b8a417db351175d90cfd5130d63784e9cd698cfc1e96108"
    sha256 cellar: :any_skip_relocation, catalina:       "e447e280c38c6fb07b8a417db351175d90cfd5130d63784e9cd698cfc1e96108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b873e8789cf3c03de9be9b8351d64104a24f3ae0a2847a3c3e5ce90dd82a2c"
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
