class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/refs/tags/v2.4.41.tar.gz"
  sha256 "3b868c820d59dd38372417efc31e9be3fbdca8cf0a6b39f13fb2b822607d6194"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "f662fcab9ba091a7ffcf39bd47ea5e41f870905a14e789a77d5024a6430281a3"
    sha256 cellar: :any,                 arm64_sonoma:   "dd564d3cdff0027c493485c2ff35c9e5d5bda6456877dcbbba375eaac4d51d5f"
    sha256 cellar: :any,                 arm64_ventura:  "dc32a609274e337d4372a480187edbef851a031ab654f7ed96d4063bc2b568dd"
    sha256 cellar: :any,                 arm64_monterey: "3db503b39d5c54fe63767b5904538ffe0e656706bf0d575d5b4aa3fbf710d491"
    sha256 cellar: :any,                 sonoma:         "971e7b2619817f1ee848298cb8520e8c5f04bf5cb312cf822bf398a9f533353f"
    sha256 cellar: :any,                 ventura:        "1b6e6b69ae7a9893e81ff2f90f2b9e395f4d49cf9480b919597597054438c9b7"
    sha256 cellar: :any,                 monterey:       "dc2dfc7bfc8d29e1591a73b7c9697de4b8161a312acc1c1fcc0c9a311c1bc055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df0184574d41dcc2f66a7ec2c762c7e142475f5557631de50883e4f0556d421"
  end

  depends_on "jansson"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Apply Debian patch to allow using system/brew libraries
  patch do
    url "https://sources.debian.org/data/main/b/bedops/2.4.41%2Bdfsg-1/debian/patches/use_debian_libs"
    sha256 "e9ec0c4603a6978af2eb2fc998091de855e397a456da240169140ad4dcbeae64"
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
