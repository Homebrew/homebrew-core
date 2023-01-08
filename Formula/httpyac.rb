require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.10.0.tgz"
  sha256 "d73a9014cfe4d5f02fe826f57ce90edac7f20e5a32a78bc17bb5a20bdfc51b00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c8cd4404a74f299254f71f7bee73e306541e171d4b2bea5cb738012fd173ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c8cd4404a74f299254f71f7bee73e306541e171d4b2bea5cb738012fd173ce7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c8cd4404a74f299254f71f7bee73e306541e171d4b2bea5cb738012fd173ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "689d7e43aef3ef4b67d9baaae8c2ec6e10a90bdb60285be9dc207da0ebbf54d1"
    sha256 cellar: :any_skip_relocation, monterey:       "689d7e43aef3ef4b67d9baaae8c2ec6e10a90bdb60285be9dc207da0ebbf54d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "689d7e43aef3ef4b67d9baaae8c2ec6e10a90bdb60285be9dc207da0ebbf54d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8539a392225c173aa5d41c1a2a0a57be9f2ffe00034492bc1ca44a7e2a771d"
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
