class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.16.0.tgz"
  sha256 "349541fdb294e783fed6a9ca2ee1819ed56f099cb67768608dbd44c21623edb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec41acd6b991caf7391e248439e78a4d7f3672dc1eaa5a0776dbe87cd8fb389d"
    sha256 cellar: :any,                 arm64_sonoma:  "ec41acd6b991caf7391e248439e78a4d7f3672dc1eaa5a0776dbe87cd8fb389d"
    sha256 cellar: :any,                 arm64_ventura: "ec41acd6b991caf7391e248439e78a4d7f3672dc1eaa5a0776dbe87cd8fb389d"
    sha256 cellar: :any,                 sonoma:        "e72fccfaa111bc506375923a3f061cfa5eff01c37ddf403b2da573194c68622a"
    sha256 cellar: :any,                 ventura:       "e72fccfaa111bc506375923a3f061cfa5eff01c37ddf403b2da573194c68622a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e24b582343f7346004c51f8abbf4ca310077ca4947f4bc076cf94856c343feed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
