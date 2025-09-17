require "language/node" 

class Lazycommit < Formula
  desc "Writes your git commit messages for you with AI using Groq"
  homepage "https://github.com/KartikLabhshetwar/lazycommit"
  url "https://registry.npmjs.org/lazycommitt/-/lazycommitt-1.0.10.tgz"
  sha256 "a7f888b386988d4eaf6b070cbab33f0690945b6011e01d1a0005544c0450f363"
  license "Apache-2.0"
 
  livecheck do
    url :stable
    strategy :npm
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "lazycommit", shell_output("#{bin}/lazycommit --help")
  end
end
