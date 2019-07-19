require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.11.29.tgz"
  sha256 "6b013642a5a9ba86e930363f99ff650c470fea2598a1f2df9f0b28f1e1f28757"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "43b94f763ec5579f33633645318eadef63171438b612b9d6a5f0cf4af9baef8a" => :mojave
    sha256 "36333fd8e9a437b6de48d9c212e2426336c7963b761f902246e1e635609f362f" => :high_sierra
    sha256 "04adc2418ffa364e237541400f11f915afb46e3000b0559e048a0f9fcf341d02" => :sierra
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
