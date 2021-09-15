require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.0.tgz"
  sha256 "dbe38a880655e48986cfab25f22f1f8c3a2a46eb9879f2bd77c827257227efd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "500cac9dd61632a58302936043e728abd78dbe673897a5285bae1be3e77bc110"
    sha256 cellar: :any_skip_relocation, big_sur:       "62268dd74681e909e204435b539e14d9f673486a265db913cd57375ad308c93f"
    sha256 cellar: :any_skip_relocation, catalina:      "62268dd74681e909e204435b539e14d9f673486a265db913cd57375ad308c93f"
    sha256 cellar: :any_skip_relocation, mojave:        "62268dd74681e909e204435b539e14d9f673486a265db913cd57375ad308c93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "500cac9dd61632a58302936043e728abd78dbe673897a5285bae1be3e77bc110"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
