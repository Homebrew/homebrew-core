require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.7.3.tgz"
  sha256 "75d8e8b76f7fcff73bb33cd4d443093cff7ef418c7f245e793e9e087738105a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cae19b9fe615c4cc75df85f2439bf93504043efbd4b91be5c624b2074e99629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cae19b9fe615c4cc75df85f2439bf93504043efbd4b91be5c624b2074e99629"
    sha256 cellar: :any_skip_relocation, monterey:       "f0355edd3309bd6fe621344e1bca865701c9ed4fe507aefeba53c7a30685ea22"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0355edd3309bd6fe621344e1bca865701c9ed4fe507aefeba53c7a30685ea22"
    sha256 cellar: :any_skip_relocation, catalina:       "f0355edd3309bd6fe621344e1bca865701c9ed4fe507aefeba53c7a30685ea22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea5fc03c0770ea0d7325ca85455bc2326181d0cd135388203291a1f8bbaa070"
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
