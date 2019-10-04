require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.149.tgz"
  sha256 "26b1c4b80db58148e934852016687ced1c617f1841afc9b1e5eea00e10e20c8e"

  bottle do
    sha256 "d5c541119dc009ea3aab6743365b6bd5f2618e3f2417aa13415520ad316a7434" => :catalina
    sha256 "3ccf9eab20cc4060a365b0fdb4db8cce99ad70760a020babfd49e43352e3e806" => :mojave
    sha256 "3485137bfee6a3fb88ce5ed4ca27616a1cf016b44ccfdb87c0cc82f996bd0566" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
