class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.0.2.tar.gz"
  sha256 "fa80a8685f0fb1b4187fc0a1228b44f0ea2f244e063fe8f443b8913ea595af89"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea9e376a25e8cfef2483a9306aed25f641a11ab9a62782ec0290ff40e9d09a73"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b7ce84aed98a1ad38a48f93f428dc83a0982ff3fde005a03fff2cea8f68b7f7"
    sha256 cellar: :any_skip_relocation, catalina:      "9a1155dee1c102d31b873fe16144c2e99f1982bce1d7dbce541d6baf83eba489"
    sha256 cellar: :any_skip_relocation, mojave:        "2632bd7c032c9fd7c019380c5f0266970b315e4e7b95b6c8c7963c7237c7ac30"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
