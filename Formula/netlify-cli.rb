require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.31.0.tgz"
  sha256 "6488d17378cdeab13573cac3119dd23e3f17e3d33699402f9617f5bc08bb5748"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e3fa2478dd9be7a7d9c27c5460def6a9879b65a4784719deffaf0639a7a69f9" => :catalina
    sha256 "d891dd4e6ca3d8be0a694fd1f81f31b3874397431bb64e3a7a998b608a9eadec" => :mojave
    sha256 "1dd977cd917c58bd20a62cb94708840a8ab063a012c3455093e47cf5cb587026" => :high_sierra
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
