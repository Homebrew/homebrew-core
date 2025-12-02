class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftpmirror.gnu.org/gnu/gsl/gsl-2.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsl/gsl-2.8.tar.gz"
  sha256 "6a99eeed15632c6354895b1dd542ed5a855c0f15d9ad1326c6fe2b2c9e423190"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6568c445eea85c3fb013ecaefe945edbc528d265c811dc6decc8341f3c0fcffc"
    sha256 cellar: :any,                 arm64_sequoia:  "52e3fe781b19bd2d88986005309b2d81a2af60d17a8b3dbc3d5cad4ae2c78858"
    sha256 cellar: :any,                 arm64_sonoma:   "b5cd011cc1f8ac606487224628d21247cbe290b4a035f844ab016088c82bbdf7"
    sha256 cellar: :any,                 arm64_ventura:  "5a197c4ee1e19b629de8203c0e365c7df8293c0d83cdadb38282baa2cceb926b"
    sha256 cellar: :any,                 arm64_monterey: "3b13e8f79478d63845e9f2e0f4e6b09dee7b7c139f9a789a87a1250a6e989da0"
    sha256 cellar: :any,                 sonoma:         "a955529c333b0d646bdc2ea92c821b5280d2451090e999e159e78e6d274a24a0"
    sha256 cellar: :any,                 ventura:        "0b59031c0d9af903b2c1fc50e98022199a802ce5e44ad554a81bf763a2748806"
    sha256 cellar: :any,                 monterey:       "0d90b773e23b6892e7c90a6a7a1cd9bc8b647f50abcf5e39adc520af9ee7d93b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8c55a27d42637c2063546598efe69937d9b926b760598e326fb035938f64fe57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fb92934fa28882ef82232f29289132270d1de558d75452644668a8fdcd630a"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
