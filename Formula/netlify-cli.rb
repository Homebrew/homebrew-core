require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.5.tgz"
  sha256 "516269e4e7ee4ebed1568b49475114199458846fcaf7ebe02ecf8fa1ef3cd9de"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1c5e8bf53bac5a49c087416a3fb341704146aff37124d55f0cf6a77356ade52"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9632858f0082e0bcf72dfabec8e7f23ed9c2aa03d8de154cd9a94a0b56a42e5"
    sha256 cellar: :any_skip_relocation, catalina:      "50f92fd66783d3e0beacec3393c8af7618755924457b9d1f138d1e2fe7d6def7"
    sha256 cellar: :any_skip_relocation, mojave:        "50f92fd66783d3e0beacec3393c8af7618755924457b9d1f138d1e2fe7d6def7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab456b8ee1ccb2b67988d3cff3006002e9264c955ffc6f1808e7beff97af2c3a"
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
