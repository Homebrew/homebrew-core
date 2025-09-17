class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "029c5d1167e884fee54fc99881e3d8c30478314f6e5fc2a7b832c909ed35d5b0"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "feba0ec17eac5b598935a376ed97b160837728ea1dce7368ab984e48134ac80b"
    sha256 arm64_sequoia: "e7f8a694f90c7451ed9abda3ca69e35d1dbab001ede6afcc97b37f8042524c69"
    sha256 arm64_sonoma:  "d173769e2e4ee2b4882e64afd3ba3496ab82a17fd8d127b4ebbcf86b54e8d535"
    sha256 arm64_ventura: "871cc1ebb9efa92af51e3287dd5ba4bc421f27992cc10c5a948462d272996857"
    sha256 sonoma:        "2b504cc81e146e8e75402fe12649f6da73a28e80333610172f3d2c0ecca3ea50"
    sha256 ventura:       "8254410f35da04c44f861955b609e0e41c4d5d54590d40a71c19f4922cc93811"
    sha256 arm64_linux:   "a8dd83896bb983f2a5885e3fe873bbf65a5bfc4d18c6ecf0ba07e5ae736c06b5"
    sha256 x86_64_linux:  "9c4e5283fc854c1e1489d98ef5d234163222567da81348d751084d2ba138ac11"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
