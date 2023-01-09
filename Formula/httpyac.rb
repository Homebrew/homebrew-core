require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.10.1.tgz"
  sha256 "1a4f7498564261b244010665ff61e50b1b8ea12ec7616b14185e0693c1d76964"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd04949ea38c563268f633e1bc05b5cac4639cbcf1e641b84d7b25e511140220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd04949ea38c563268f633e1bc05b5cac4639cbcf1e641b84d7b25e511140220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd04949ea38c563268f633e1bc05b5cac4639cbcf1e641b84d7b25e511140220"
    sha256 cellar: :any_skip_relocation, ventura:        "2519e57fbe721b934e9d5b6cc3b58074fced01e4eac096d190f5cef205361394"
    sha256 cellar: :any_skip_relocation, monterey:       "2519e57fbe721b934e9d5b6cc3b58074fced01e4eac096d190f5cef205361394"
    sha256 cellar: :any_skip_relocation, big_sur:        "2519e57fbe721b934e9d5b6cc3b58074fced01e4eac096d190f5cef205361394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f25bb2f5acaf17c27018ef4977eac1cdf54a82d9cd27dba47271e3a3c3cad5a"
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
