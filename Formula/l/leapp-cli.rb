require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.43.tgz"
  sha256 "61dfd04842146cc0109a2ab7e22fd86873aa7a7889e64f1a063e05a7c817054b"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "7eea6cc9ad78fbcdcc35cf58856c8fc3a3d5725d8ceccd5db4d287d1a30567ad"
    sha256                               arm64_monterey: "96c5ca6c14f128b71cd9c15384321089219bda05b515802fdc6216fcac7cc2e9"
    sha256                               arm64_big_sur:  "ee96029f26de3d14298bd1c8076e7053a4eec7bcb1c7218fa5449f2d03d53e34"
    sha256                               ventura:        "8d2213d793d778100f717d5c7ba15a90cb6516220f3238f3db2f97e839599e8e"
    sha256                               monterey:       "80d8cba3e774a7fed23808fbd8a9f83828bf16f3c4e1298a3ef074af1469094d"
    sha256                               big_sur:        "8aa1bfe132d3d8e37e560c14550d4cc63cb5ab2e355ee3b73d49b1018e6354ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b015ef119a604ac812c886b3a385f64e5423078df6a590a4019cf974e498553"
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
