class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://codeberg.org/maandree/libkeccak"
  url "https://codeberg.org/maandree/libkeccak/archive/1.4.2.tar.gz"
  sha256 "a0c15046d0922f20ca5ca2b632181b5f4c37038c3a740127af2751ee37583181"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2136f3cbe1f2e62462e58c25820af5eb9cc110a855daa84871d7179bf4b19c91"
    sha256 cellar: :any,                 arm64_sequoia: "70977efcdb774de369d24949c0e01429980706b72369428da2a7d63b87f3c0d7"
    sha256 cellar: :any,                 arm64_sonoma:  "f60cca3b212fb9e7347b2b6fbfe40320871f340dd8b1c7cef1b82f1f051e2cec"
    sha256 cellar: :any,                 arm64_ventura: "f36edf66bb02643f97a5aa6bd18330839ee173537a10961e38eaf5c99ea9f2a0"
    sha256 cellar: :any,                 sonoma:        "b86b8c1a529602eec5de64c6d78f820baf7c611b22ddcbc32b187eb73cdfd700"
    sha256 cellar: :any,                 ventura:       "40d03f81b05b53dbc8ca7e6e5c3de4890a2dbf5665d376f5f2a55d57f232bed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e520ee48c95376e0f23d47dfbf70c36589ea5c50612cdddc7c4cec2546f1f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffb9b214f2a9ac56836f8459caa910d8077dc26cc93e85989a72fcddeee3df5"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "OSCONFIGFILE=macos.mk" if OS.mac?

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end
