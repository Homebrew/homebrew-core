require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.8.0.tgz"
  sha256 "da9fbaa4163057622a47d613a931612c4483062fd3b0d8ff9739b60ca30d9a02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08d32087f047a9c421b108f9f31da4115fcfd7db28aeebbbe435804f886ab65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f979d16efacce5779891e40bd88e33855183d94199470861bcb92d248a5bc0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f979d16efacce5779891e40bd88e33855183d94199470861bcb92d248a5bc0c"
    sha256 cellar: :any_skip_relocation, monterey:       "715d13f3596e7e83e8bc6077e6fd3063c066c35974f52b4ed3e263e0a3a78dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "715d13f3596e7e83e8bc6077e6fd3063c066c35974f52b4ed3e263e0a3a78dca"
    sha256 cellar: :any_skip_relocation, catalina:       "715d13f3596e7e83e8bc6077e6fd3063c066c35974f52b4ed3e263e0a3a78dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "384a1eb6b29aa0bca9851f3c4fbb5aaf9bf03606afdef937cd676a4a8359d583"
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
