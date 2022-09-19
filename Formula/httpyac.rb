require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.7.1.tgz"
  sha256 "1d05dfc15d107e2ae781e66f92f8404b39f4f0d14a2d7a1d308a0f97b1014fc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31771a4cc1273aa72a3ddf5f12701cd578faece2a7c116139589f1ec359bf7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31771a4cc1273aa72a3ddf5f12701cd578faece2a7c116139589f1ec359bf7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "ab1407f4ed9d6c9b8043b337b48a448b7649af94b3baa6565dc25c830602f0df"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab1407f4ed9d6c9b8043b337b48a448b7649af94b3baa6565dc25c830602f0df"
    sha256 cellar: :any_skip_relocation, catalina:       "ab1407f4ed9d6c9b8043b337b48a448b7649af94b3baa6565dc25c830602f0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276c9782c699563138aa2b7f2452ba482484a40489697081c60fe9878b258fd8"
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
