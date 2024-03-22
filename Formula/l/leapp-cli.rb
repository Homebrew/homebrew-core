require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.65.tgz"
  sha256 "a770256e2ce62f08c17650a30e785e46f92e7acb03e2bcbdec949054467b711c"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "95490933985ac191a11b046a2b032858a03cfd4994342fc65a5736d7d9dcc4e7"
    sha256                               arm64_ventura:  "08d47e74e06f75c3619d703f29ff8ca67f408a1f2c0c9852f5dcb24a9c66e792"
    sha256                               arm64_monterey: "5bd83996ed049cc64b2117d7fc4cdd71bd1e0bf401b27bdd5ee0d418657a7193"
    sha256                               sonoma:         "2d903ae070c2a5dec9c800fa5aec0f05a8b65b08c44556ab283cad5062cc56c3"
    sha256                               ventura:        "4041465dd93d488dcf06ecf6b0c9bb2835a84b1d8cdd1dc3f9996c014f9e44c7"
    sha256                               monterey:       "b1e27f9ef7df7dc07dc2de94a7e16d7a0f6610115eb348e045f42f02ae475865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6314712fa2196365e54d599f2482707af827774256690a328921deb1e3fc867"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "python-setuptools" => :build
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
