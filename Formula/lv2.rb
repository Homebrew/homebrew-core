class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.0.tar.bz2"
  sha256 "90a3e5cf8bdca81b49def917e89fd6bba1d5845261642cd54e7888df0320473f"

  bottle do
    cellar :any_skip_relocation
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
