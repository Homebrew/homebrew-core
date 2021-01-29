require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.4.6.tgz"
  sha256 "46306446c1a1df1bfa0a9138ec2e608652cbfba6e26cb1472bc1e7cf368fe13a"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5b526e8d4c36837f79428d01872b5d1ac8a495e8871ba4953f43a566cc12ecca" => :big_sur
    sha256 "c91d1e2be39205db743d7d742004719b109b4ad718eff7696f6314ed6b4f148f" => :arm64_big_sur
    sha256 "0ecca1ff9c38b0ad88924f8ade628d2dd753eb0445da010ad03bf6e04efea3a4" => :catalina
    sha256 "a1ea0bfe1dccb23870b52005c92040458d7d92031bb5daced1c6dd944753ebba" => :mojave
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
