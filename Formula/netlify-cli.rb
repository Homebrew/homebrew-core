require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.65.7.tgz"
  sha256 "99ba81d59769aebf1e5c0ae5f58d3d509ba4121a8cd8081bd98245c2b829e527"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "065100289d617efab91e7368cda00fb49fd7a5628c5212731755f1718df359c3" => :catalina
    sha256 "c935ccd449d259cc10324525051dca0b0dac1eb590aff9e7588f66f5efd81f1b" => :mojave
    sha256 "f40a5ed3aee940bdffc595a37182ac6b200b78df9598436dead82bae9204ad7b" => :high_sierra
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
