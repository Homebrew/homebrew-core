require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.12.0.tgz"
  sha256 "21a2c92bc9963188de3dfcaecb9f1a8ff03c8289f65691c3f0ddb0b33dba85c0"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a50416fda601fd34062dd7c21d72af12850e5eb52444409a7a530849540476e" => :mojave
    sha256 "5371f681c39bd5f4b2e41b69847effbcfab911a24439ad488bd383b5a8011a10" => :high_sierra
    sha256 "017b1da36e8278246b39f9a8a07c2701c012b1e3a280679e4cc07cb94d316f54" => :sierra
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
