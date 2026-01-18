class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/archive/p/flow-tools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flow-tools/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "2204560fae3ac7eff92549b4fbfc7475fd3ea527ab62ef1f0b2b93ce2a778532"
    sha256 arm64_sequoia:  "f99aa518b7c94faa3be0ea9d263a7de70ef5778f65c5f620cee6b6e03f42b2d5"
    sha256 arm64_sonoma:   "84db73f5e249e77d5aaef609008c7fcc3d3667262a9e0c1c7f07b14870e31f51"
    sha256 arm64_ventura:  "c90987ead84d52f84bf1f156cd04ef871b4aa2a47ceeb26dcef0a4c6d97f25fb"
    sha256 arm64_monterey: "21de46ca9080f98898aaeb06a9b33b0c56c7246dc8f01443939b9b621186fc92"
    sha256 arm64_big_sur:  "2b3f15c05b798474764d6efa91aa0fb31d8f24fc4291b3c0c37d450a9d15e1d0"
    sha256 sonoma:         "d2638337270268f5a43d2903f6f1abc422dcbe08d2edc149703b528ace2a383c"
    sha256 ventura:        "65926d38c6c80db3795420c4693c2ff10f2d0976350bf1ec8df88267e29d4a77"
    sha256 monterey:       "07a3f8962e183463a3780df8867e6bb5f02d238f550e14eaf9157ba1cb84b0a8"
    sha256 big_sur:        "871477b9ba37ffd6ff5d85c96cac7602c3df7c420422071ca03bcc296f8f24e7"
    sha256 arm64_linux:    "61f4c991d614265a39f70712db315f5abc4da60b9d574383fb465e06bd6772b2"
    sha256 x86_64_linux:   "30934a57a2b7c02704b76e05e81106f7e4aeefab82b7b23ef8f86a368639f74a"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Apply Fedora patch to fix implicit function declarations and multiple definitions
  patch do
    url "https://src.fedoraproject.org/rpms/flow-tools/raw/5590477b99c33b61a4d18436453a29e398be01aa/f/flow-tools-c99.patch"
    sha256 "ce1693d53c1dab3a91486a8005ea35ce35a794d6b42dad2a4e05513c40ee9495"
  end
  patch do
    url "https://src.fedoraproject.org/rpms/flow-tools/raw/61ed33ab67251599c26a2e2636f1926b0448ab8a/f/flow-tools-extern.patch"
    sha256 "3b0937004edfabc53d966e035ad2a2c3239bcfccdc1bacef2f54612fccd84290"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
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
