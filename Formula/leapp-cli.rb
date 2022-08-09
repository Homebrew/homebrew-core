require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.17.tgz"
  sha256 "7ba69db4b1d16194fa3f7bdaff61f9fc0facad6644eef96b5dc18382714879d0"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "2412ab1717c409df2e551d1a6ecae275872f40829059e7b1ca3ef992f43f9c02"
    sha256                               arm64_big_sur:  "d436583b53a723cbb3929e0db5ac65497f4e78ca03c28aab26e9a96a7b2f6f3d"
    sha256                               monterey:       "75264d151c0785c37f79fa22dcad9761828987391d5999693c83bad28e482d55"
    sha256                               big_sur:        "af5de2c33085a4553d51f4f5a7726bf867d1f8852f28a1cbce029faab0db62ba"
    sha256                               catalina:       "2c403b7dddd94360058ad053614fa90ebd5950c4c013f33baaea32678fc67bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262777184bf08816eab0b2478c88dac7081fe3140f17488530f7a59a29e1d493"
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
