class Ocmtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://github.com/acidanthera/ocmtoc"
  url "https://github.com/acidanthera/ocmtoc/archive/refs/tags/1.0.4.tar.gz"
  sha256 "dbc33ca5d5ae436b2845e36fc13ba878261480788db86fc6daab89dc5588e51a"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34843bb5ba58430a17255e04a445bf40be5d88c9063c0a322d5b7659c2b7cc4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1600fd106867c86d9c5d570832bf95bc07ee70cc735ebca1ff04b5191206dcb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb37d60cdc18321191054e2118463722ab18bb30460b0c40a9efabfd86124a6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a3e4f56aa7092771863408c858c5979dd929a1b38440c60f1618a41c8e40d87"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "mtoc", because: "both install `mtoc` binaries"

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "cctools.xcodeproj",
               "-scheme", "mtoc",
               "-configuration", "Release",
               "CONFIGURATION_BUILD_DIR=build/Release"
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
