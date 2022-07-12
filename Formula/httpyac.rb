require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-5.5.3.tgz"
  sha256 "6952a5b6875c77fe0174621a93614c3612224388e50f45da506c14d8bed33022"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbf8603170396739ff3c284ec66b548b5f8431bd263968837063c14d8e182c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfbf8603170396739ff3c284ec66b548b5f8431bd263968837063c14d8e182c9"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e1643a3bbfeb4fa13b3e1d7bb3e2a23a6f110e4e64d84be66e44e9a1a263b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7e90cc1c0cfd270c1e77af127826660f656a7504881639d5a85e1e96cc97a56"
    sha256 cellar: :any_skip_relocation, catalina:       "d6e1643a3bbfeb4fa13b3e1d7bb3e2a23a6f110e4e64d84be66e44e9a1a263b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439343fb36fc6487f86bef660b4cccbace32bda9e0fad1f66e5a3d45badce17f"
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
