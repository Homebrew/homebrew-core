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
    sha256 cellar: :any,                 arm64_monterey: "397e18518b0779fffc7d007d72cffea54a26d9e6f874a56fe77846acdb229b38"
    sha256 cellar: :any,                 arm64_big_sur:  "7adb58b280cbfe2cfb21b09a2587caef52ccdd366f4d7886d3059221f6334e32"
    sha256 cellar: :any,                 monterey:       "bed10dee0c56b449fdba441e61190f46486b456680296125e5a49ce8297860ff"
    sha256 cellar: :any,                 big_sur:        "80dad8c3e92edbf4a37d3d5e36ff82ca1afc7cd048c44800a04e63ab9d6678b9"
    sha256 cellar: :any,                 catalina:       "764f569513dee5f39b4044e2c56cd89cf0fa98c6d1e1f4e07c3a2c7d0918f86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09cd03cdda63f5a1897eb54a876c4f17aa02ab656eb13e40d6ca20014ca19354"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end
