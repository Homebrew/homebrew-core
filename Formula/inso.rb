require "language/node"

class Inso < Formula
  desc "CLI for Insomnia"
  homepage "https://insomnia.rest"
  url "https://registry.npmjs.org/insomnia-inso/-/insomnia-inso-2.3.2.tgz"
  sha256 "3ae32671053f87957b508f40a2ffd5a610b03cae85ecffd801432c8288abcc03"
  license "MIT"

  depends_on "node"

  uses_from_macos "curl"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    output = pipe_output("#{bin}/inso --help 2>&1")
    assert_match "Usage: inso", output
  end
end
