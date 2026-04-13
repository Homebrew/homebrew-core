class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://github.com/RIPE-NCC/bgpdump/wiki"
  url "https://github.com/RIPE-NCC/bgpdump/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "415692c173a84c48b1e927a6423a4f8fd3e6359bc3008c06b7702fe143a76223"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b7466c828dd9c4dc63b62c670ad9bf9270ae4b7b4a512ad7ea6d4f3852100879"
    sha256 cellar: :any,                 arm64_sequoia: "d19e671a817e8cca5f105ff661bd83aac226068487e581761b712f7b02b966d2"
    sha256 cellar: :any,                 arm64_sonoma:  "226e863cc55bca02b1a990adc902f28f53c619ab14e4c6e35b198795637f31ea"
    sha256 cellar: :any,                 sonoma:        "ec5587f68240ae4c67304b2d3a95d3b4956436c2cacebf2d8e40c3f7a4947efe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9301becc1293c918c53f5699ff9ed9f6973d685e9c5fc91550199031d0aae91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e87438d5bebcb4e594b7af638eb0f5b81b89838a5deca962c319d1027a25d7f"
  end

  depends_on "autoconf" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"bgpdump", "-T"
  end
end
