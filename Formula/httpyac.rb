require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.8.2.tgz"
  sha256 "49833eaa4694739141382443fbd48e2a06be1aa3bb967bcb81f525773967bcdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c730807eb8cffdcd525f38f5365c4299c2e39d862f6731cc8931b4ea84855925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c730807eb8cffdcd525f38f5365c4299c2e39d862f6731cc8931b4ea84855925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c730807eb8cffdcd525f38f5365c4299c2e39d862f6731cc8931b4ea84855925"
    sha256 cellar: :any_skip_relocation, ventura:        "20ae7375a727f30d066a2e16e355018f81a1c39a63a9ab3ed02111e80929dbf0"
    sha256 cellar: :any_skip_relocation, monterey:       "20ae7375a727f30d066a2e16e355018f81a1c39a63a9ab3ed02111e80929dbf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "20ae7375a727f30d066a2e16e355018f81a1c39a63a9ab3ed02111e80929dbf0"
    sha256 cellar: :any_skip_relocation, catalina:       "20ae7375a727f30d066a2e16e355018f81a1c39a63a9ab3ed02111e80929dbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d3be4bbc93222e1b032ff5bed5516f0990b2587885b961a2a6a27658d5cb03"
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
