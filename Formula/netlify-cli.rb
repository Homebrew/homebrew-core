require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.57.0.tgz"
  sha256 "b9af8cc3428c03e7d82a3e0ac4200263e16be5bbc04a8622a1984471d30b51e7"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fd0abf82ca697cf735b3c392527416c6c1c6b74517b8a5500fd88e8452f273e" => :catalina
    sha256 "a9405823f971db9487aa0a6397669d9aa627dfbc203933886f91f61cb2bed9d1" => :mojave
    sha256 "d9309dee67109da27e4be8e8af4c21f42897914ca0ebbcc901a5e5fe7e837821" => :high_sierra
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
