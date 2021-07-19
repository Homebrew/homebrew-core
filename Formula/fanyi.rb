require "language/node"

class Fanyi < Formula
  desc "Mandarin and english translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-5.0.1.tgz"
  sha256 "0f80edeac5e727a299c2a0807f463231143d59b46fd8308ef794390b9d88052c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi lov 2>/dev/null")
  end
end
