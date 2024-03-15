require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.65.tgz"
  sha256 "a770256e2ce62f08c17650a30e785e46f92e7acb03e2bcbdec949054467b711c"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "9dd622d94917192125d035e104012bedc17236ab00f852da88470c8c2975ac48"
    sha256                               arm64_ventura:  "56d6b206f5db49159dc6e52e98705133f50d7711af314f4a8a907a771edc2636"
    sha256                               arm64_monterey: "6b7b6cf985006bd22a72a2eb46576fd423ac4da69659ffbaaedefbb468110957"
    sha256                               sonoma:         "719d8382677bab6c0679e0fb0a8d623ae1fbdf9694431cd66d6c7f53bd2d1f10"
    sha256                               ventura:        "2eeedb9c309a6f18ec530184b5c82069a9912f27df8cb91d035730b7bcffdb84"
    sha256                               monterey:       "8440860a5d1f643d67a066a9f1f176a006a99d77fb05979ee2a71edbc804d0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2629db9ae39cef24d500ef4bc83de7bf641482320c58607d4e540d46e23cd653"
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
