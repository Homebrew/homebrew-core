class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.15.0.tgz"
  sha256 "0744a1fb716cbacddce5af066a76536bf6a7784ba404af5a42976eec9834ac4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec333f3a7c5408c3b0ae4abadba1ba9aec8dbb9668bbd53150aa76b9e98e53e6"
    sha256 cellar: :any,                 arm64_sonoma:  "cfce092c1d6a4748df04e8811039bc79f5c083a9be0fd7c14a980aa5441e21c2"
    sha256 cellar: :any,                 arm64_ventura: "a614d57ec68ed6b8dc0d6b925d53daa40c7598fb7f59b287cc660b8657c340f2"
    sha256 cellar: :any,                 sonoma:        "2da89aacb0b7d0cc02eeb3674e0db60f38ec9b939e1c4df138b927d612e4759a"
    sha256 cellar: :any,                 ventura:       "2da89aacb0b7d0cc02eeb3674e0db60f38ec9b939e1c4df138b927d612e4759a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a041cb47a37908b4f3484b45130b65ea5772d51e9763c377c8bde3c1b1b71baf"
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
