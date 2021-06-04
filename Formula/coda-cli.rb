class CodaCli < Formula
  desc "Shell integration for Panic's Coda"
  homepage "http://justinhileman.info/coda-cli/"
  url "https://github.com/bobthecow/coda-cli/archive/v1.0.5.tar.gz"
  sha256 "5ed407313a8d1fc6cc4d5b1acc14a80f7e6fad6146f2334de510e475955008b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "660574bb0a6fb2cbc99ee5a41cbc06df8e927d7726345a56ed6892e94e2bb6a5"
  end

  def install
    bin.install "coda"
  end

  test do
    system "#{bin}/coda", "-h"
  end
end
