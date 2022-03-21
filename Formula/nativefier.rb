require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.2.0.tgz"
  sha256 "386f40c1726330af86832fc41e776b0f043bf5dfafaa8f9f01038947c124a9eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34f7a80737122b19c2380eb34e6688e84a1b1d714467bd92305dbf5c835efed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34f7a80737122b19c2380eb34e6688e84a1b1d714467bd92305dbf5c835efed"
    sha256 cellar: :any_skip_relocation, monterey:       "97ec968b652f09ac80876c277621b5ce7d90be53cdb7f2a22d33477813f19124"
    sha256 cellar: :any_skip_relocation, big_sur:        "97ec968b652f09ac80876c277621b5ce7d90be53cdb7f2a22d33477813f19124"
    sha256 cellar: :any_skip_relocation, catalina:       "97ec968b652f09ac80876c277621b5ce7d90be53cdb7f2a22d33477813f19124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e34f7a80737122b19c2380eb34e6688e84a1b1d714467bd92305dbf5c835efed"
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
