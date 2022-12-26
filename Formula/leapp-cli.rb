require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.27.tgz"
  sha256 "94291cf5dc98dad11a23eb91ed94df708a1b72e711d4a789c2535d355b49b46b"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "ed63cca1c920fef5802febac97d956ed3953253e43b4c8af58924885981b2440"
    sha256                               arm64_monterey: "f4c4b3bf0ff431ab5b1319226102d51070f7b067e24b7dd326c2bb24b6116b24"
    sha256                               arm64_big_sur:  "cfcb00f10ea4e13df0b214e4a3a121d14f06404b6326f37104daaca670ccd387"
    sha256                               ventura:        "70af45f1994111995c3f38f733ccff54fa8f119a624372b2c6e6f88ad94c112d"
    sha256                               monterey:       "c684b7964a07c2d9aef8657e92e0fde03714e3df743decead8ea4b8714aecec1"
    sha256                               big_sur:        "b41bad0253ca27e5913d010ebf606962632adc4e2bce40353de5622eca71d300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612ff4adebe582302566af18ed7667631b83fc2e436a60e9d5a668329fc0b65f"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
