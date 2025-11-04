class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.20.tgz"
  sha256 "23c89a3d6a134f58988ba20f2e417f84491c251421398c3a4c0fdfd8d7ea8534"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "080f0a93cefb17fc4e124ffffba2d6526127c30d83b5987178d4fa6603abcd80"
    sha256                               arm64_sequoia: "080f0a93cefb17fc4e124ffffba2d6526127c30d83b5987178d4fa6603abcd80"
    sha256                               arm64_sonoma:  "080f0a93cefb17fc4e124ffffba2d6526127c30d83b5987178d4fa6603abcd80"
    sha256 cellar: :any_skip_relocation, sonoma:        "c757510ef7503675d10ac874cdf66d15be7553eae8729cff83fc7e2cdec39fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8466471b4c51daf7663859839fcc1eea76fc206377e3963f1b289116b2c69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d1f8de89a8e5177f30ccd63dca750978a75abb26ef6a7b9eb879abd99753d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
