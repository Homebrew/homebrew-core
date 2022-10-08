require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.7.3.tgz"
  sha256 "75d8e8b76f7fcff73bb33cd4d443093cff7ef418c7f245e793e9e087738105a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3507c8940e8eaaa0675d708e7b7712492aaa81a4c61d702ab059665c6bfd5a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3507c8940e8eaaa0675d708e7b7712492aaa81a4c61d702ab059665c6bfd5a24"
    sha256 cellar: :any_skip_relocation, monterey:       "6441e5889d25cbcfe06e3fad63bafe553041030dd8d82d4486b29a884472641b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6441e5889d25cbcfe06e3fad63bafe553041030dd8d82d4486b29a884472641b"
    sha256 cellar: :any_skip_relocation, catalina:       "6441e5889d25cbcfe06e3fad63bafe553041030dd8d82d4486b29a884472641b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35055b47ed82dea936c8c0a6fbe2897b0541321d2a5b694f1bb16a2b147b986c"
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
