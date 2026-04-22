class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/refs/tags/v2.4.42.tar.gz"
  sha256 "9daa0c098e37490a07f84664d2c61ff8909689995cf7e1673d259ccd4f1c453c"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "02db95f7031e865972ba9811475cebf53b0bcd748ae61b0fb067187a5940de88"
    sha256 cellar: :any,                 arm64_sequoia: "163148476ed1d1b00d3a4b281bfb32db9830928844d81d25e7d6a6d5f6b1ecb8"
    sha256 cellar: :any,                 arm64_sonoma:  "ccac5a7e4985f27095efd08464c9c51b158dee343f2d5a017d3d69e6065076a7"
    sha256 cellar: :any,                 sonoma:        "6f996efefbe566889602342fb2d270816c30121dfa1798125010bd59c70c7071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e60fd9252b86986cef3dd7adb62756695775f3747f120e44813607532881468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ffc6cb770da1fc79d627c28daa4cf7a6444f3203e1c17f9c78860f70521738f"
  end

  depends_on "jansson"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply Debian patch to allow using system/brew libraries
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/bedops/2.4.42-debian.patch"
    sha256 "7d88db7624500521988d5260ec290578db74e85ad4b0cf0e1552e548691c3a21"
  end

  def install
    rm_r "third-party"

    # Avoid running `support` target which builds third-party libraries.
    # On Linux, this is already handled by the Debian patch.
    inreplace "system.mk/Makefile.darwin", /^default: support$/, "default: mkdirs"

    args = %W[
      BUILD_ARCH=#{Hardware::CPU.arch}
      JPARALLEL=#{ENV.make_jobs}
      LOCALBZIP2LIB=-lbz2
      LOCALJANSSONLIB=-ljansson
      LOCALZLIBLIB=-lz
    ]
    args << "MIN_OSX_VERSION=#{MacOS.version}" if OS.mac?

    system "make", *args
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    (testpath/"first.bed").write <<~EOS
      chr1\t100\t200
    EOS
    (testpath/"second.bed").write <<~EOS
      chr1\t300\t400
    EOS
    output = shell_output("#{bin}/bedops --complement first.bed second.bed")
    assert_match "chr1\t200\t300", output
  end
end
