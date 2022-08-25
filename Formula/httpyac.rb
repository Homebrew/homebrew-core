require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.6.5.tgz"
  sha256 "4a1d09726470493ff38a8dd692fde8c2c040dd6efd3cea1c08cdaf029230a0c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d208d709eabf852c2369663400628da33ee76592bf16e152e0278c35059c2a73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d208d709eabf852c2369663400628da33ee76592bf16e152e0278c35059c2a73"
    sha256 cellar: :any_skip_relocation, monterey:       "69f37568385f096f38f68527124d929679d133a6b86804c1b18b654eece0cf27"
    sha256 cellar: :any_skip_relocation, big_sur:        "69f37568385f096f38f68527124d929679d133a6b86804c1b18b654eece0cf27"
    sha256 cellar: :any_skip_relocation, catalina:       "69f37568385f096f38f68527124d929679d133a6b86804c1b18b654eece0cf27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958faf89c5d2c19a7910f10f9dab4549d0204f732c677512ff347339c42585e6"
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
