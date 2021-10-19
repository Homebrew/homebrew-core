require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.14.0.tgz"
  sha256 "7b8457dc47018c46d16449ec66beec8eaa2b7d1149f9da24165cf91b46c378c6"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e642542fd532110be4054d624978341d8430712d0cd0c16b6a84cf22ecd2e081"
    sha256 cellar: :any_skip_relocation, big_sur:       "635b11f35185965aa96a92baa59ce212b4fb09cbd98bb1be3621327dba0a944f"
    sha256 cellar: :any_skip_relocation, catalina:      "635b11f35185965aa96a92baa59ce212b4fb09cbd98bb1be3621327dba0a944f"
    sha256 cellar: :any_skip_relocation, mojave:        "635b11f35185965aa96a92baa59ce212b4fb09cbd98bb1be3621327dba0a944f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab34ea462d39263729b7e5d8ae58bdb3e8b5de0bbe454a426d797ff834d6467d"
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
