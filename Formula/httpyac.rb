require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.6.2.tgz"
  sha256 "246c0082d782e79a61d3a434286680bdb71fd54a8f92532bd0d44d709e0e1977"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e2b14cd6e21a6058222ca8a5df6bafb35fabddfc79e5fb6d83a949b473ecda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1e2b14cd6e21a6058222ca8a5df6bafb35fabddfc79e5fb6d83a949b473ecda"
    sha256 cellar: :any_skip_relocation, monterey:       "2a01dbedd45f427127c5c669fdf8a94a6d68a8de57e4f8895b86d186ad079bb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a01dbedd45f427127c5c669fdf8a94a6d68a8de57e4f8895b86d186ad079bb6"
    sha256 cellar: :any_skip_relocation, catalina:       "2a01dbedd45f427127c5c669fdf8a94a6d68a8de57e4f8895b86d186ad079bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697d930fa4d4c7a33e5d168a2476a8056e20e1e0829915ab1d203742dc9f100e"
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
