require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.3.0.tgz"
  sha256 "5f0a012d25832632d94434fe6c4e0d9277ebd7139e075d3af7a3598a09b9f721"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4534c0924e3cba4f4cc519076f146c195d337f87cca5ae06ab7818314890718f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4534c0924e3cba4f4cc519076f146c195d337f87cca5ae06ab7818314890718f"
    sha256 cellar: :any_skip_relocation, monterey:       "280e6f8520791b3fb43532867c28d66da33d0af0e6c26ea7a607eff0e5b3fde8"
    sha256 cellar: :any_skip_relocation, big_sur:        "280e6f8520791b3fb43532867c28d66da33d0af0e6c26ea7a607eff0e5b3fde8"
    sha256 cellar: :any_skip_relocation, catalina:       "280e6f8520791b3fb43532867c28d66da33d0af0e6c26ea7a607eff0e5b3fde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c6c5436c92fbfae9f06bfa550db3e5a869304a46fa39f412745dbed1b07889"
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
    assert_match "2 requests tested (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
