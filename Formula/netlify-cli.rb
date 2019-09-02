require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.13.1.tgz"
  sha256 "d5540311b858673ec752f02a9915252cc0ecdc73870d65cbbff206f9929439e8"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "2533ee11c178d7a815d646f9a0636306e77f8050c0c157e8cfb88c287ad31018" => :mojave
    sha256 "9be777041828894cff35e103025833f6913c32090b05a6a6b1120e0dc8033984" => :high_sierra
    sha256 "73965f6063dacd13f331079ccd125916f57cdc84a6c86466149722f2696ae40d" => :sierra
  end

  depends_on "node"

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
