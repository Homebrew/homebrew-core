class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"
  license "GPL-2.0-only"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b1784d64cd680875fef331fcf995c64399e0bb96f7f6ab5dd721c535c235f9b6"
  end

  depends_on "cmake" => :build
  depends_on "mbedtls@2"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    args = std_cmake_args + %w[
      -DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE
    ]

    system "cmake", *args, "."
    system "make"
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system "#{bin}/dislocker", "-h"
  end
end
