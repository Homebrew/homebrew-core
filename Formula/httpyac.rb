require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.5.5.tgz"
  sha256 "be602acb58af1e6e403675226de44e99aea88550af4cac486caeae3ee6529b0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a0cfc3fba863fc106127c13e7a3c169ad242217b84a7c3e25e5998bbfea569"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96a0cfc3fba863fc106127c13e7a3c169ad242217b84a7c3e25e5998bbfea569"
    sha256 cellar: :any_skip_relocation, monterey:       "4fbf1b7140bf9d590b7fad815908f7922197db213f00f1f6b0c544800f3223e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fbf1b7140bf9d590b7fad815908f7922197db213f00f1f6b0c544800f3223e3"
    sha256 cellar: :any_skip_relocation, catalina:       "4fbf1b7140bf9d590b7fad815908f7922197db213f00f1f6b0c544800f3223e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e248dff1c6b38db44a18832af1fbbd73ab184424a143767bc4ae011b66ef111"
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
