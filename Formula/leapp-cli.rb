require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.25.tgz"
  sha256 "88c469d6c0952b8d4816f7278e524746b30240cb8d43db67574ea00512cc7b19"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "c7ef97fdba85e3b87e5af063e7f511d26d512755f89db40c0af0905ecb8f9157"
    sha256                               arm64_monterey: "092e7b5069da340ff4cb27d49f877f40c6dbaa25df2afa1945179ae471604ce8"
    sha256                               arm64_big_sur:  "a73c95b047ee858fd7e9aa6956d2c33716267b1cb862b0ffa79c3a98caa12082"
    sha256                               monterey:       "64adb60dee8719d85dc0111a0424973939a5083a84520ca50c7058bdc7e42548"
    sha256                               big_sur:        "94df625da8d533e69e1b4161fcd1283226edaac59513cc72cf4aa1ea3edfac5b"
    sha256                               catalina:       "f39b51a89c92e0f9a9cc7e7a474ac1076e0cacc9b427c60bbe96a26f1b03e403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d71f170b968de501e23883c9f8b1e7a25865425ac468e9add771d831eb2eb3"
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
