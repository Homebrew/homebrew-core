require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.15.tgz"
  sha256 "408d06dfbf5291f6eda330dcfb6ab6c1f5e4f069f46a22aa3f5bab5808b4daea"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "c551e0ea7e91368196e5d3115f2b23e4a5ee8258fd7d4b5ecd6511c9311a0053"
    sha256                               arm64_big_sur:  "52dc62e26ce66e53b158d2577c40748b763976c2d4f620c74b2f4fd2c39a6942"
    sha256                               monterey:       "7b63e02a8f1ee4a338077cf3e9949370dae6156663588296a2220743e6e20962"
    sha256                               big_sur:        "06565c608e97bc21531d1ba49c3d7220c09800dd6ad086c38e6398d5638f1dd7"
    sha256                               catalina:       "063376c839afb373836e9084c8260153e654b8148cc1da9e2eb0c9d87357f656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660393e05d0e3fe2dcd8aec4fcc1d00f0cdcd14d0174c9f6c8994f933c1044cb"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
