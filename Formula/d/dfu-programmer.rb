class DfuProgrammer < Formula
  desc "Device firmware update based USB programmer for Atmel chips"
  homepage "https://github.com/dfu-programmer/dfu-programmer"
  url "https://github.com/dfu-programmer/dfu-programmer/releases/download/v1.1.0/dfu-programmer-1.1.0.tar.gz"
  sha256 "844e469be559657bc52c9d9d03c30846acd11ffbb1ddd42438fa8af1d2b8587d"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6e4e503268ee717e7eb68d2849204d017e4a1cab2094cf80363b92a73dce1adc"
    sha256 cellar: :any,                 arm64_sequoia: "9d8e4b2ed240a48c18c466631c2157e6d7b3d640d205cdda06ddfe86a3751b7f"
    sha256 cellar: :any,                 arm64_sonoma:  "f506d34a6fae7808ea684cfa1a293eba7ec7b21e3527229cad5e2d89c289f65d"
    sha256 cellar: :any,                 arm64_ventura: "6bff3958c7c8e1b569b374e9e1cdec4843c70f7e2f9042c05a9fae9f6832fe27"
    sha256 cellar: :any,                 sonoma:        "5b70cceeddad497b6a6f55d4ee1ee66caac51f8395f69f8389edee88427eab97"
    sha256 cellar: :any,                 ventura:       "7924fe1214155edd5e6467e29c31981efaebad2d0aa92f484e5021e2f7c4ea3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4441fc79f4dcedbd0fc31a378d696967323dfd5ba6ba5efe888ee6aa0d5e37e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "775806218241479471ea7a2b823545e81d898f867f4c887119641aabda2c926a"
  end

  head do
    url "https://github.com/dfu-programmer/dfu-programmer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libusb"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "8051 based controllers", shell_output("#{bin}/dfu-programmer --targets")
    assert_match version.to_s, shell_output("#{bin}/dfu-programmer --version 2>&1")
  end
end
