class Dsh < Formula
  desc "Dancer's shell, or distributed shell"
  homepage "https://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "https://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.10.tar.gz"
  sha256 "520031a5474c25c6b3f9a0840e06a4fea4750734043ab06342522f533fa5b4d0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfort.gr.jp/~dancer/software/downloads/"
    regex(/href=.*?dsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "cbb546751736cb2f93c9f59a4851ad2157a1440e5f5e914c15f5efb8800f2196"
    sha256 arm64_sequoia:  "d73aea65a96f05c4040e1b38d8238dbaee979d65c886c388b3eb7d7f5b388295"
    sha256 arm64_sonoma:   "5ffc7bafd29a43adc43ae8eaa2d85d51c2231c62fce48da0103f310c9620387a"
    sha256 arm64_ventura:  "adc8a26e4eaaa0762e985cf8ad18e3249ae5854807672860f1250e181b88901a"
    sha256 arm64_monterey: "a4100e069145478ff23600954f9e30f93ae3f8e2485cf254899a1ee281080b2a"
    sha256 arm64_big_sur:  "5e691ea82431b5921a5ce57f26e0219c0f5c38decd4249c3fb49beed4f284c4b"
    sha256 sonoma:         "a271df504a6cf92cb16de16b9200f42190c2aa0dddf70827c11ba0cb935519c4"
    sha256 ventura:        "54000d6f2a6da19c9a7acefd4b5d59b434deb9adf5ba957e98116032b11a06d8"
    sha256 monterey:       "2fba1c82686d6522582b09a4d7048c8685a56b10ef355c3a2895f3d7a4ba1fbf"
    sha256 big_sur:        "8179e3e553da0ac7b40a6b69c0cd47283ce7ab80f399e0f84b57210fa8b6784b"
    sha256 catalina:       "96b9dda875dac2f33db11bd912a9fd1babac7c2baa76fc0036386442dafaabd2"
    sha256 arm64_linux:    "07d63285b278ccbbedc618fc2722652b7bde0b671c25aa98cb1e1a34cbe3506e"
    sha256 x86_64_linux:   "b0489652a4291212811da8fdc746690777acbfaafd90f0dfd050fb4699e57734"
  end

  depends_on "libdshconfig"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    # Use GNU sed on macOS to avoid this build failure:
    # sed: RE error: illegal byte sequence
    # Reported to the upstream developer by email as a bug tracker does not exist.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
