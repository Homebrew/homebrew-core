require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.10.2.tgz"
  sha256 "e3d4a8d091d447f81ae043b101171721aaf2bf913a84c092c821e0525a04040f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ec218ff30b344175c44e1c460704a1c231b7aa80dda21116aa55ded7824a511"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ec218ff30b344175c44e1c460704a1c231b7aa80dda21116aa55ded7824a511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ec218ff30b344175c44e1c460704a1c231b7aa80dda21116aa55ded7824a511"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ac47974d24700141cac51357b57ca902d6bcb3f84fffcbc53ebbf562e4bf25"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ac47974d24700141cac51357b57ca902d6bcb3f84fffcbc53ebbf562e4bf25"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9ac47974d24700141cac51357b57ca902d6bcb3f84fffcbc53ebbf562e4bf25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c191e3576b600c91a7959072d3ada36741d6b00b1fbda0ae28fead7ebee652a1"
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
