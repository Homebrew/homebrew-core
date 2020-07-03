require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.3.0.tgz"
  sha256 "9457e671e3bbeb114b6abfdf4323848a5fd1c4e9616fd8865079dd5bc93594c8"

  bottle do
    sha256 "1a1cd43449289e17cee991e60872d303b26c338b037e4e52e0e4e3f2ad6bb603" => :catalina
    sha256 "4b2701babc77af9b4f96430bf30f0646b315405f6398ff38fa486c69d0a19031" => :mojave
    sha256 "ae8f56791b14ebf36f7f101bb3e4af9e996a157cc1b7a46e8a20449bba43e7f6" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
