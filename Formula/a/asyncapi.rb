class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.6.0.tgz"
  sha256 "2fe2bde8c58606becbce7d80e63d261285f9aa73fc5b6e079b163f61392dac9d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5086066a196cc3808a4937a8b9e4ec055d050b29884abb5f307e0727796ff18"
    sha256 cellar: :any,                 arm64_sonoma:  "a5086066a196cc3808a4937a8b9e4ec055d050b29884abb5f307e0727796ff18"
    sha256 cellar: :any,                 arm64_ventura: "a5086066a196cc3808a4937a8b9e4ec055d050b29884abb5f307e0727796ff18"
    sha256 cellar: :any,                 sonoma:        "ef7770438cfdc93f23b59396f1986a2e5ecf7c8650b8402d7bb4faf88828c701"
    sha256 cellar: :any,                 ventura:       "ef7770438cfdc93f23b59396f1986a2e5ecf7c8650b8402d7bb4faf88828c701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bf4c7f274db3a01372fe63d0586751ee585fff7ff259addb87bc6ed894183e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
