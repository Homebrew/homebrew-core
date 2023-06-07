class Dsh < Formula
  desc "Dancer's shell, or distributed shell"
  homepage "https://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "https://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.10.tar.gz"
  sha256 "520031a5474c25c6b3f9a0840e06a4fea4750734043ab06342522f533fa5b4d0"
  license "GPL-2.0"

  livecheck do
    url "https://www.netfort.gr.jp/~dancer/software/downloads/"
    regex(/href=.*?dsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "adc8a26e4eaaa0762e985cf8ad18e3249ae5854807672860f1250e181b88901a"
    sha256 arm64_monterey: "a4100e069145478ff23600954f9e30f93ae3f8e2485cf254899a1ee281080b2a"
    sha256 arm64_big_sur:  "5e691ea82431b5921a5ce57f26e0219c0f5c38decd4249c3fb49beed4f284c4b"
    sha256 ventura:        "54000d6f2a6da19c9a7acefd4b5d59b434deb9adf5ba957e98116032b11a06d8"
    sha256 monterey:       "2fba1c82686d6522582b09a4d7048c8685a56b10ef355c3a2895f3d7a4ba1fbf"
    sha256 big_sur:        "8179e3e553da0ac7b40a6b69c0cd47283ce7ab80f399e0f84b57210fa8b6784b"
    sha256 catalina:       "96b9dda875dac2f33db11bd912a9fd1babac7c2baa76fc0036386442dafaabd2"
    sha256 mojave:         "e978724605a216f2e3ffc5df3ba12bb53e3150aa63b7d18779723e563a35f867"
    sha256 high_sierra:    "5d553941319eae8d839a53063057fff05b359eb13e53da2d7313c3d41fae88b0"
    sha256 sierra:         "9d694a476e5d74d7c3edbf284628e3f68c96c5a30c91b7fd3c624630805636ea"
    sha256 el_capitan:     "0b6a147235228473634c424e5e12671b6e9a4609ce6b732dd5ca9f56f335add5"
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

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
