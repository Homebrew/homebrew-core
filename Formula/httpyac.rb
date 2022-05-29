require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.4.2.tgz"
  sha256 "07fa483b4555df3e001ea65839425ed773918f0a8f8a96506ce8b7a4e12d6b0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c277e9c94452207461614f0b7b0b26cf7e1559b9aaaa8786d055f382f6aae5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c277e9c94452207461614f0b7b0b26cf7e1559b9aaaa8786d055f382f6aae5d"
    sha256 cellar: :any_skip_relocation, monterey:       "311c313db215f162e2f21dea8268df349804c2f31d610f028e27f2c237335ef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "311c313db215f162e2f21dea8268df349804c2f31d610f028e27f2c237335ef9"
    sha256 cellar: :any_skip_relocation, catalina:       "311c313db215f162e2f21dea8268df349804c2f31d610f028e27f2c237335ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a6a9e19d58bd38dd2bf8a66669f51fe69ba0e8fab0d970da514703946fd0aa"
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
