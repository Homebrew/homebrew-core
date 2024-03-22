class DfuProgrammer < Formula
  desc "Device firmware update based USB programmer for Atmel chips"
  homepage "https://github.com/dfu-programmer/dfu-programmer"
  url "https://github.com/dfu-programmer/dfu-programmer/releases/download/v1.1.0/dfu-programmer-1.1.0.tar.gz"
  sha256 "844e469be559657bc52c9d9d03c30846acd11ffbb1ddd42438fa8af1d2b8587d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6618b70e9b243bfdb165adbb46ee46c9c4dbe9d9913710351819f3055049e84b"
    sha256 cellar: :any,                 arm64_ventura:  "c7abf3562a37b1356cdd4462aa7c6ada63c4b4393a1ab3f6e1491fd113abccba"
    sha256 cellar: :any,                 arm64_monterey: "a8110021b2738f533615e1f7e961e2ef536f3a13fd3dbf2efc4d4bd1be0f7509"
    sha256 cellar: :any,                 arm64_big_sur:  "23cbbc0db021a543e010b2fd56d2a391739183388f8c1428bcb54efa961dab14"
    sha256 cellar: :any,                 sonoma:         "832ec017d2d128d991b48cd2f35d1260c10ec158714787971944a1adc41ecfbd"
    sha256 cellar: :any,                 ventura:        "ef6b41b4e7597f4bd8fe3f0f829a3a1b17fc653267c40f6ae2662d2020ddd097"
    sha256 cellar: :any,                 monterey:       "f0af0119d6d41fa35a9fb875d15270b842061e3fb557a195f904b8f76f5bf6aa"
    sha256 cellar: :any,                 big_sur:        "9933ccea13d42b9fbc76c7539f46be4123cc3e17b17b0e595d7780fa7ddc4510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b49dbbfb38d200869a2aa405a699cecbaf7dda8fb7d50f45da43ea817345114"
  end

  head do
    url "https://github.com/dfu-programmer/dfu-programmer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libusb-compat"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-libusb_1_0"
    system "make", "install"
  end

  test do
    assert_match "8051 based controllers", shell_output("#{bin}/dfu-programmer --targets")
    assert_match version.to_s, shell_output("#{bin}/dfu-programmer --version 2>&1")
  end
end
