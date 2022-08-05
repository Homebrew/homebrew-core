require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.6.1.tgz"
  sha256 "c5817fb2be47249abcb097ed565337e08f9ca9ff2fce36abbf1b61a4f0d348ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85ebdd25828cb6d77f47822fbbb824c1ac14351091e3c8cde15988f5a61deb97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85ebdd25828cb6d77f47822fbbb824c1ac14351091e3c8cde15988f5a61deb97"
    sha256 cellar: :any_skip_relocation, monterey:       "3f52480ddeeaf14c3f241783c04b7ff523489e4949cf0e4e2136a26d0c4400c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f52480ddeeaf14c3f241783c04b7ff523489e4949cf0e4e2136a26d0c4400c7"
    sha256 cellar: :any_skip_relocation, catalina:       "3f52480ddeeaf14c3f241783c04b7ff523489e4949cf0e4e2136a26d0c4400c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6181998b78e7c35dce8766d865b246545ccc17320a5a259b49b1ded61f38ea3e"
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
