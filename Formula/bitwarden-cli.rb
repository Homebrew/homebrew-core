require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.13.3.tgz"
  sha256 "afb2d19f4a2c153a7a9978a48b394f013d3c472bb23b0bf46dbcb2f53a7eed54"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d8d85b4f14d7b98d7ca5844741fc5009c21500724e9ce034b1ebc5298c54f667" => :big_sur
    sha256 "169dc03c6e32060e3e8e32e9cd61d58e386b52238c4ff0d9d830bba84015a7c2" => :arm64_big_sur
    sha256 "ef80f95534d1e0731599620dbbd06d8297a1b4c83a486b14a9c2f507313422f9" => :catalina
    sha256 "32f5ccd2ac760504711915d3291c0787a4b6b477ad44670b9c351d909a455167" => :mojave
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
