class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/v0.1.4.tar.gz"
  sha256 "2613b57778df4466a20349ef10b9e022d0017b4aee9a47fb07e78779f444f8cb"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a2201cc3f5028be6c18b5ddc25f04330bc7839100ec339a937619f4af77d73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173967f25b9a31abea026ec8407772ad49342790d788a310ec236089d3de78b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "758130aee49d62c9e306cb7d918e3159e2171e81983b2e29c8703a88324eed73"
    sha256 cellar: :any_skip_relocation, monterey:       "777f831f84ac617912b6986abe746e6fed8f7281977481f304d1c3e55440bb37"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d34f32e85384bc92262c412c8a91ee01bb3e81a2430deb248db2b175a4ec125"
    sha256 cellar: :any_skip_relocation, catalina:       "278533a0a51eb1952eb4f95b7f7d68a3fe7cff3ae5968d5a91605f1b91c0a04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d4a6dca4a3bf8a4bba5b08c804e97ad97fb133c2e11190539da4409d7dc737"
  end

  depends_on "rust" => :build
  depends_on "diffutils" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    _output, status =
      Open3.capture2("#{Formula["diffutils"].bin}/diff -u a b | #{bin}/diffr")
    status.exitstatus.zero?
  end
end
