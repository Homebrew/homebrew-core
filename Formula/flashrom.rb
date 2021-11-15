class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.2.tar.bz2"
  sha256 "e1f8d95881f5a4365dfe58776ce821dfcee0f138f75d0f44f8a3cd032d9ea42b"
  license "GPL-2.0"
  head "https://review.coreboot.org/flashrom.git"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "7c862cfd8fe14cccc7ab27cf41c6a0f97ce9ff536209b348014391ad93d45fc9"
    sha256 cellar: :any,                 arm64_big_sur:  "644f1d260c436590fbab9fbd11f946e57a9c56ee43911c8e1d6ea47f3775a1a0"
    sha256 cellar: :any,                 monterey:       "3a2da3a282bcd81282d21cb06574ef8ba8b3c258b17c9311363fb0d5434c16a5"
    sha256 cellar: :any,                 big_sur:        "aa5c0856318732adf6a2bb4b980cef8a21829bd6a606beb357cae3ca71561217"
    sha256 cellar: :any,                 catalina:       "301d0aafe8b31a53e6ee77217ce2280d1e998ceb7c8bc1a54a85c88afa940a33"
    sha256 cellar: :any,                 mojave:         "69131a69023cd0336b8c9c9f1a56cafb28509f1e8eb5ada0bd45ff48357df38c"
    sha256 cellar: :any,                 high_sierra:    "08d74d59cb4a56347de27465cc289b6494199951e2d251fafc328b4dc2f3e1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a894f6e3ec7f6eaaf960b53ec6539b6bdd5c778acd9de461e8b787c9f3d4670"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi0"
  depends_on "libusb-compat"

  # Add https://github.com/flashrom/flashrom/pull/212, to allow flashrom to build on Apple Silicon
  patch do
    url "https://github.com/areese/flashrom/commit/0c7b279d78f95083b686f6b1d4ce0f7b91bf0fd0.patch?full_index=1"
    sha256 "9e1f54f7ae4e67b880df069b419835131f72d166b3893870746fff456b0b7225"
  end

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system bin/"flashrom", "--version"
  end
end
