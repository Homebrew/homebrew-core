require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.7.2.tgz"
  sha256 "dbd034279bd622a00ab3ecf367de1ad21c38ce38f2391af79f613a9535b1950e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29bad27080ba30d35af66a18ec32ad15c605740fe289b67d81b55110a65719f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29bad27080ba30d35af66a18ec32ad15c605740fe289b67d81b55110a65719f7"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1f6911b394870fbcacfe7e6a14f1eefe3f762e02d803e6ed110a9463aa7fc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa1f6911b394870fbcacfe7e6a14f1eefe3f762e02d803e6ed110a9463aa7fc4"
    sha256 cellar: :any_skip_relocation, catalina:       "aa1f6911b394870fbcacfe7e6a14f1eefe3f762e02d803e6ed110a9463aa7fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c484c6db0652035c40ba0238cd57996fb39376ba9b82303d7e4e0b0c77fc9121"
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
