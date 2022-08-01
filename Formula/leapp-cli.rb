require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.15.tgz"
  sha256 "408d06dfbf5291f6eda330dcfb6ab6c1f5e4f069f46a22aa3f5bab5808b4daea"
  license "MPL-2.0"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256                               arm64_monterey: "fa76e24aed7da3f084585c75eefd0f8a0bed353af3fe33132f780bdfb11a5690"
    sha256                               arm64_big_sur:  "b88501ffd2707219fb17ad2b2b6a85aadb9704f668449fa90eb6e051803e65fd"
    sha256                               monterey:       "88e4b93484bfc687d1a39dd1df019d9d83147a611f76e1ca1bb17346a45e609d"
    sha256                               big_sur:        "272674d4d72f9cccb475660f4eb86284bc2a8979dfb2ebe22b21406e31ef20a4"
    sha256                               catalina:       "0f5ac650baca5b1719aea5b4b1c45e45866b5870ebae34a39b62edcc5e5dff1e"
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
