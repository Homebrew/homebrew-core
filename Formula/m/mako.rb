class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.13.tgz"
  sha256 "3e2a477aeca74b019cc0e0cce6b32fd037dc1341c25d2ead6611d3c96c2c3224"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "4043d5bc511b77161949bff0ff87f98c53517d8fa91a79b4126ed5389b62e2a5"
    sha256                               arm64_sonoma:  "086135b5bd9e82f9f930d13635d97852f5039e882e02f818fe02b0d4a2222bb9"
    sha256                               arm64_ventura: "792ea4098a0ebfebec6e2fb845c0de69b4576c14239bce48fbb6f3b32b674b9c"
    sha256                               sonoma:        "7c830d9059692326354512a161d8ed54a05a6df7d02044adf1fe611a8fa60426"
    sha256                               ventura:       "33d23d9184957979c8dd65b9320948095781c829851b4bd1efbd3e220170cb5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf1be3d38f97a3c293f32521e3706913dcc1863351713f9874aab6e3b9ae12b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
