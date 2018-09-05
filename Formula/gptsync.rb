class Gptsync < Formula
  desc "GPT and MBR partition tables synchronization tool"
  homepage "https://refit.sourceforge.io/"
  url "https://downloads.sourceforge.net/refit/refit-src-0.14.tar.gz"
  sha256 "c4b0803683c9f8a1de0b9f65d2b5a25a69100dcc608d58dca1611a8134cde081"

  bottle do
    cellar :any_skip_relocation
    sha256 "76d760477b55a2ac3ebe3d2fb472e70ccd84a2fa8cb265bae829669e639897f3" => :mojave
    sha256 "8d21fa7f491b5cfe7a2c809a99d753ff4511c5354c4761751ab9c5abebd585c6" => :high_sierra
    sha256 "e822ef6c99aeaf6eee5812cd83ede2bc9a045dd556105150293bcf486898a59d" => :sierra
    sha256 "d355de7bea36e310d22ed1109a34574ab93859bfe9e44b9493ebe75cfe429c33" => :el_capitan
    sha256 "34756250a7bbd8470dd98401c86c65d9886cfac802adb2371bf0a23fa9351f7f" => :yosemite
    sha256 "77233898efcd0dee5ec73bf8a11294bd5f6c64f5f7d34136c792d1e96ef13d61" => :mavericks
  end

  def install
    cd "gptsync" do
      system "make", "-f", "Makefile.unix", "CC=#{ENV.cc}"
      sbin.install "gptsync", "showpart"
      man8.install "gptsync.8"
    end
  end
end
