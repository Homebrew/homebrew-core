class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.0/bittwist-macos-4.0.tar.gz"
  sha256 "5d641545b51fe57bf0d17fb4851e19495d1ff991af0a9ebd518bdeee40a905d6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1475299b1c09752d41c0be5b9fd0266a4478e96579e5a238bde7132905d8137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8e0f482e1ee331a020108b3226f6be9b76c546c0fadf0c49c096fe23c747b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "050ac4fdf436f2a6f98885d8c3098f5ae3b22e94a350332325bb2158c937f38c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d7458421c0d67f493c5668cb21b4f1da2ed0b80dab11db98fe742adc917541"
    sha256 cellar: :any_skip_relocation, ventura:       "9d64e2d431d5239842a692db861f9e5811fb78cf2d12527078e55ae590a02070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d16751cc39a55286892970de20e677403203b9fd6762af81c115d4af3ea8c5e1"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end
