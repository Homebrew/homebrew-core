class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/refs/tags/v2.4.42.tar.gz"
  sha256 "9daa0c098e37490a07f84664d2c61ff8909689995cf7e1673d259ccd4f1c453c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ff22f322da3637f4386dc02c4ab65a66792ec39e12c5cef947318b9192d8f7d"
    sha256 cellar: :any,                 arm64_sequoia: "a4233322968c5020044fae4eebb8454b89f21f0a5d8e148a354d6e6ce34c29a1"
    sha256 cellar: :any,                 arm64_sonoma:  "20bb111818a6579c66d41e8f1197db5e2bfec0a552683c613a502f6c948bb545"
    sha256 cellar: :any,                 arm64_ventura: "d76e57a5614cc8aa3ca1f80c578a3f1927afdd38b0c6781f661decbed04d9b9b"
    sha256 cellar: :any,                 sonoma:        "8f697e9debc25f693bc1ae11b4cda7ca24c9daa5473337185d498b25de092232"
    sha256 cellar: :any,                 ventura:       "28016580353e6377af02c3238032cad2eb0053a09ee84fcc98ed3f6a161def52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75447ca25f0cc6f2c06a93085e0ca3724ed9fa26ebe46a3191f0a3af91c3d1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc3de7b8daff4e67a1dcf796e5ae9ddb12954d88eaeaac332ac30c0c22159ba"
  end

  depends_on "jansson"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
