require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.5.0.tgz"
  sha256 "166df57dc4be94b5a79ad6a2e03e79d3d039f0fc1af1a0d87e3730a7f4fc91f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a740bf561facb3986f73844684721712e03da419ee80d7d5bb2068761662ce45" => :mojave
    sha256 "4f39ce2f4dd8ca29657cb602acd756bf400e36456c169b7c4cdd862f26814f7f" => :high_sierra
    sha256 "dbcd481afa77308ebf874e8395ad8c3ac6c0240c42e18b03c2de868e6c495365" => :sierra
    sha256 "778f6aec5e6c934d6543f625eb7686cacf186b8779a2de57a90cfd854ddd2d72" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
