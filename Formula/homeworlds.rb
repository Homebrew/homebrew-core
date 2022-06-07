class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
      revision: "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  license "BSD-2-Clause"
  revision 4

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0e14216bfa947bba3dce2cabc92d15d6728eaa28f3eb0817d4b96a8e06db3783"
    sha256 cellar: :any,                 arm64_big_sur:  "c09cbb2ce42b5625f9aadc56379ad001647386123395c43196943bc9d2528781"
    sha256 cellar: :any,                 monterey:       "caea0dce749f2e7ee1977b01ef54f6ff3a044b2346c0e1162da3b1291b7c491b"
    sha256 cellar: :any,                 big_sur:        "c133cb6a5eef778b85fb75622147710a5f3668322c5401a8078962724ea1e603"
    sha256 cellar: :any,                 catalina:       "1a46da701b7ecc11098f014d354ffc1140f1fe44cbaff59e959d941d912deb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221937160080213724eefdb95f2e82822ca060c154115a66fae7e46ec739d702"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end
