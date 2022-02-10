require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.2.0.tgz"
  sha256 "5451b3336add2446bef5f4d491750233b6841cb1113c13bcb2414a5ad3872fc1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28fad7bb2971eb5aff667566327685b9243d181e8bf4a59d1df87b329aabe417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28fad7bb2971eb5aff667566327685b9243d181e8bf4a59d1df87b329aabe417"
    sha256 cellar: :any_skip_relocation, monterey:       "35648256473ec8bef6895940b9295bc4557c4e017f964fa97d9fbc42b41bf90b"
    sha256 cellar: :any_skip_relocation, big_sur:        "35648256473ec8bef6895940b9295bc4557c4e017f964fa97d9fbc42b41bf90b"
    sha256 cellar: :any_skip_relocation, catalina:       "35648256473ec8bef6895940b9295bc4557c4e017f964fa97d9fbc42b41bf90b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022db5cdda6e27c24a8c90818517052e9d275b15bda8591bf0dc900ffa6c2187"
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
