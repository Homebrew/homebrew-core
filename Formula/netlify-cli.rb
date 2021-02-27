require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.1.tgz"
  sha256 "c0303ed694886a3733bdc2f9b9bbc212b1b31f94eb3c623931bda1ad2243239a"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a9f2cc240b6c6db527ff7cc833ce5213cf7c9205c26c98f5af2d30991c57b18"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e70012c7bd598db9cb72c8b60f0b4e28bbedc512bcd31294b19e4094ba6eefe"
    sha256 cellar: :any_skip_relocation, catalina:      "44805f53342abd2c2ba090d5723b863eef78360db194b247aed5ecbc3d8c86c7"
    sha256 cellar: :any_skip_relocation, mojave:        "b6ab474d9a85c82dad072c58ce06591a2ac46e8064f5e1047b6fe766b1b1eca7"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
