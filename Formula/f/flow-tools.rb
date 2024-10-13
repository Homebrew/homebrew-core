class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/archive/p/flow-tools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flow-tools/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "f99aa518b7c94faa3be0ea9d263a7de70ef5778f65c5f620cee6b6e03f42b2d5"
    sha256 arm64_sonoma:   "84db73f5e249e77d5aaef609008c7fcc3d3667262a9e0c1c7f07b14870e31f51"
    sha256 arm64_ventura:  "c90987ead84d52f84bf1f156cd04ef871b4aa2a47ceeb26dcef0a4c6d97f25fb"
    sha256 arm64_monterey: "21de46ca9080f98898aaeb06a9b33b0c56c7246dc8f01443939b9b621186fc92"
    sha256 arm64_big_sur:  "2b3f15c05b798474764d6efa91aa0fb31d8f24fc4291b3c0c37d450a9d15e1d0"
    sha256 sonoma:         "d2638337270268f5a43d2903f6f1abc422dcbe08d2edc149703b528ace2a383c"
    sha256 ventura:        "65926d38c6c80db3795420c4693c2ff10f2d0976350bf1ec8df88267e29d4a77"
    sha256 monterey:       "07a3f8962e183463a3780df8867e6bb5f02d238f550e14eaf9157ba1cb84b0a8"
    sha256 big_sur:        "871477b9ba37ffd6ff5d85c96cac7602c3df7c420422071ca03bcc296f8f24e7"
    sha256 x86_64_linux:   "30934a57a2b7c02704b76e05e81106f7e4aeefab82b7b23ef8f86a368639f74a"
  end

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Fix for newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: acl2.o:(.bss+0x0): multiple definition of `acl_list'
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Generate test flow data with 1000 flows
    data = shell_output("#{bin}/flow-gen")
    # Test that the test flows work with some flow- programs
    pipe_output("#{bin}/flow-cat", data, 0)
    pipe_output("#{bin}/flow-print", data, 0)
    pipe_output("#{bin}/flow-stat", data, 0)
  end
end
