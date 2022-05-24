require "language/node"

class CashCli < Formula
  desc "Convert currency rates directly from your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-4.2.1.tgz"
  sha256 "593e2b02aab0e4369225a2c78a895d511ee491a1708e44d7aba63d9a897b000e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11e8b5cf3e977adc9dde41f31173b5a1403d72da4dcdefc277e31ea22cf30612"
    sha256 cellar: :any_skip_relocation, big_sur:       "17d36688d320b64dd29f64127d3c05e2cb03de8a3a4e45d4a18016ae58abc675"
    sha256 cellar: :any_skip_relocation, catalina:      "f22f6404f47adb8a6c0253362d61fb529da4d6a71045a2902407ed112329310d"
    sha256 cellar: :any_skip_relocation, mojave:        "7aa6e66eef5defae364924b00859ad4d884a15563c52488462ab489676f02141"
    sha256 cellar: :any_skip_relocation, high_sierra:   "903fde1135bcc71b70d74b852084897a2708f1d87ad00c200c793600472c42aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25e658a1049c359059b393257727a0ef80487633e0994a1451eb38e1f448955"
    sha256 cellar: :any_skip_relocation, all:           "71505f2abc52d632bcdf71e08c4fcebad55506a9f9b547c81a8dae39cac15a5b"
  end

  deprecate! date: "2021-04-23", because: :unmaintained

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  # Test is no longer fully accurate
  test do
    assert_match "Something went wrong :(", shell_output("#{bin}/cash 100 USD PLN CHF 2>&1", 1)
  end
end
