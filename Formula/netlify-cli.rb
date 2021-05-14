require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.14.tgz"
  sha256 "36296074bd6005b996fdd137144f69a140e477cfbe929b8e48f5a422740b0262"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72f52ae73bb8499d6389a2eb9534d174c6e41a68992da3f85de5a9bba2c9d89b"
    sha256 cellar: :any_skip_relocation, big_sur:       "401e20cb74a8d0e01949674f4a2c942a695cdf8412378e4ebafd88b59a98882c"
    sha256 cellar: :any_skip_relocation, catalina:      "401e20cb74a8d0e01949674f4a2c942a695cdf8412378e4ebafd88b59a98882c"
    sha256 cellar: :any_skip_relocation, mojave:        "e5d46dccb7c777d208d6f77bd4e8ca4067f50f2a99171aac1f533397408aae51"
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
