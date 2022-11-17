require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.8.2.tgz"
  sha256 "49833eaa4694739141382443fbd48e2a06be1aa3bb967bcb81f525773967bcdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42916e8b2ab2480afcf64514d8df7cb44719f9efdb4efacd9bcd34d4ec3bd1f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42916e8b2ab2480afcf64514d8df7cb44719f9efdb4efacd9bcd34d4ec3bd1f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42916e8b2ab2480afcf64514d8df7cb44719f9efdb4efacd9bcd34d4ec3bd1f4"
    sha256 cellar: :any_skip_relocation, monterey:       "6e8704d6dc4d042e6f89b43dab2d88d12f3107494fddc801cd358e21b36c0fba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e8704d6dc4d042e6f89b43dab2d88d12f3107494fddc801cd358e21b36c0fba"
    sha256 cellar: :any_skip_relocation, catalina:       "6e8704d6dc4d042e6f89b43dab2d88d12f3107494fddc801cd358e21b36c0fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9614f77b29aeb37671525bf470e8ddcbd4834401289a93d4e7bafd727ae7183a"
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
