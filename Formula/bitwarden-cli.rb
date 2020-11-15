require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.13.2.tgz"
  sha256 "0806f897dd66d31d2ee48a15aa43a9c6e796655c64221e81d9e5122c574dde5c"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d7e2975a83f08bfb62624f6262791c9d41f68df4b145d52b5455226fbbbe40ad" => :catalina
    sha256 "9731c7b2a21aaf40ce860661c419ed317c5c4e41d7ffd8f4f756ba5083e86dd6" => :mojave
    sha256 "ff9a35a1b90c030fbcc82f8d59c964eda9ab5d7048fe6408c16d14071f56c718" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
