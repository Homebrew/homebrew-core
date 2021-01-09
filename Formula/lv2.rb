class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.2.tar.bz2"
  sha256 "4e891fbc744c05855beb5dfa82e822b14917dd66e98f82b8230dbd1c7ab2e05e"
  license "ISC"

  livecheck do
    url "https://lv2plug.in/spec/"
    regex(/href=.*?lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "593bfbd7208eb8cc5ea57318af0fee430cdc0e972413fad746a943f2ae6dd7df" => :big_sur
    sha256 "0a16890b6aa8ba1ac4088c23b85f7fc769a1db21feda2cbc8925a93652e413e5" => :arm64_big_sur
    sha256 "6cafb26479b24f5b6746557359b665d03bc42dd47ee7acea5a9c0b742c23936e" => :catalina
    sha256 "6cafb26479b24f5b6746557359b665d03bc42dd47ee7acea5a9c0b742c23936e" => :mojave
    sha256 "6cafb26479b24f5b6746557359b665d03bc42dd47ee7acea5a9c0b742c23936e" => :high_sierra
  end

  depends_on :macos # Due to Python 2

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
