require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.33.0.tgz"
  sha256 "fdcfc9d6e45a4d12d0948d40a187eb6fb21f542f6c91deba570b3c3d7c22a2d0"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a70d4d6c309513cd3522bbfc164a4267a670fa11507a0fce156d8042759d0c80"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef72a99b548778a27c57aa76c87c627cbf856ec5446eb031642b2b15580475c5"
    sha256 cellar: :any_skip_relocation, catalina:      "ef72a99b548778a27c57aa76c87c627cbf856ec5446eb031642b2b15580475c5"
    sha256 cellar: :any_skip_relocation, mojave:        "ef72a99b548778a27c57aa76c87c627cbf856ec5446eb031642b2b15580475c5"
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
