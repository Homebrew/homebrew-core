class Ocmtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://github.com/acidanthera/ocmtoc"
  url "https://github.com/acidanthera/ocmtoc/archive/refs/tags/1.0.4.tar.gz"
  sha256 "dbc33ca5d5ae436b2845e36fc13ba878261480788db86fc6daab89dc5588e51a"
  license "APSL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "917fd4fced07f4d0a2670aaa0f5bdbad38b2981bad232c0c74b653885cc31826"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b14b91a85d26c6219655ee5aeb5ffd349f0ce6c0cd6966e840db79408dbe561f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f51c7a744c58df9f6ae3576de5629abdda34f1488164a8a32b96bd07436012cb"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "mtoc", because: "both install `mtoc` binaries"

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "cctools.xcodeproj",
               "-scheme", "mtoc",
               "-configuration", "Release",
               "CONFIGURATION_BUILD_DIR=build/Release",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~C
      __attribute__((naked)) int start() {}
    C

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system ENV.cc, *args
    system bin/"mtoc", testpath/"test", testpath/"test.pe"
  end
end
