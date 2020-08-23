require "language/node"

class CashCli < Formula
  desc "Convert currency rates directly from your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-4.2.1.tgz"
  sha256 "593e2b02aab0e4369225a2c78a895d511ee491a1708e44d7aba63d9a897b000e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f22f6404f47adb8a6c0253362d61fb529da4d6a71045a2902407ed112329310d" => :catalina
    sha256 "7aa6e66eef5defae364924b00859ad4d884a15563c52488462ab489676f02141" => :mojave
    sha256 "903fde1135bcc71b70d74b852084897a2708f1d87ad00c200c793600472c42aa" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Conversion of USD 100", shell_output("#{bin}/cash 100 USD PLN CHF")
  end
end
