class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/archive/p/flow-tools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flow-tools/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "c6ac8dfec95def2a25acdf33db6ddd896f473f64c402e415753a316d0eef78b1"
    sha256 arm64_sequoia: "7e2efd253c92894d3d2a423bc535eb5fea7a8507b677e1346e14cd6cc925aef9"
    sha256 arm64_sonoma:  "9e5dafcea86e53dc7e880dd4f4a978563e4e5abb7ab226386fca7f1afd40203d"
    sha256 sonoma:        "9d5da70fb239297657612492fd4448ec29ebd54612fc2e3fc77db0d0802fece5"
    sha256 arm64_linux:   "86b056849f21682bd1cb1c180e5df2e62790f79717c27f2cc2bd4d09ef3019be"
    sha256 x86_64_linux:  "6ea0a8b997faf61a95f480149b697f9ee4446674e12bf5deaf34c132a1e314e8"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

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
