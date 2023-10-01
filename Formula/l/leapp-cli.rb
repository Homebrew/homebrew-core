require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.44.tgz"
  sha256 "9e1315f9a8204073555bead50443be0c3d0c8b3c4cbcde1ab9c81dd54bde34f3"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "3ab44b6b35e451ef844bca9bb6044377506fb4d35da9db9e65a955fe311c49fe"
    sha256                               arm64_monterey: "75f6f8ee61477413c4a54f050b651b006b0ba1a3947740b3454b97291b49c067"
    sha256                               arm64_big_sur:  "017b82c0f1847de1aba6c0a5b4553cc6dd85aee869fdbce9693498edfe70c6bc"
    sha256                               ventura:        "d826665b23ec4271a14c845b465571ef3f3df0f3ec49e31537c30dd52c95d582"
    sha256                               monterey:       "61b88f0e747b0b31e0781df5b97ac3d1da043aab0fdd4d844883913359bdda1f"
    sha256                               big_sur:        "58916ddc03fcc4ecd253e94219a5a4528a75698ffeda0a8385407be1318c760c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfbde245ace91fb7947a903f73981a463e61de4a92de2484fef126dea5bbdc53"
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
