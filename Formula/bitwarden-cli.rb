require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.8.0.tgz"
  sha256 "9342aa2cd08210f3473d43de13b1edbe6e8df95e62f38e839922b2e7371381d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd522c9535bc7b6b8939f5077a664d3a878f0422bed140d70fc96da504cce528" => :mojave
    sha256 "45270b5ae13e5a07f820ae09693130bbfe86e195af76be6bcc4909c9943088f4" => :high_sierra
    sha256 "f069faf016545d9d2b720d7603a0e76c8043d16a957ce15a896d9420e22fb331" => :sierra
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
