class Ocmtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://github.com/acidanthera/ocmtoc"
  url "https://github.com/acidanthera/ocmtoc/archive/refs/tags/1.0.3.tar.gz"
  sha256 "9954194f28823e4b1774d2029a1d043e63b99ff31900bff2841973a63f9e916f"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "76c855fd1977f72607d1a5e666eb281e43d39ed12d80195f2ac223ce23a0f72f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12fda27f6b2cd588a3d5bbea9cc63834f08cf32e6b62f78b8bcee54d3435519d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78b7bf8993b3b48e9844cd01811ae6365c9ffd3880d304977ae0833f4c0eaac3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e754be1f248ee6535ac24a9b60a2bbcd4aedd7d8e6d3ade111ec7b0a34e30f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5268ef4754ba65b4b3414e39baf1a748501c5451650e72adae13b9411caeded0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7958ebea6eb25570b0ff9539c6fba863d8815fc3893d0960bd413ca8c69bbae"
    sha256 cellar: :any_skip_relocation, ventura:        "15a56ba72b6a997bf4607a99eb88bf9d6d3edcf0e5720a6ac0bcd21afd793fa4"
    sha256 cellar: :any_skip_relocation, monterey:       "8d7d0bf8c739d0d4aac299ba7a8e340ebac0e05f7ac077184cef31f24c143de6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee2274b07ea977cf6b3b66815d5c91e9d01d1b9a7ebe8df60712aded4dc0cfbb"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "mtoc", because: "both install `mtoc` binaries"

  def install
    # error: DT_TOOLCHAIN_DIR cannot be used to evaluate HEADER_SEARCH_PATHS, use TOOLCHAIN_DIR instead
    inreplace "xcode/libstuff.xcconfig", "${DT_TOOLCHAIN_DIR}/usr/local/include",
                                         "${TOOLCHAIN_DIR}/usr/local/include"

    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "cctools.xcodeproj",
               "-scheme", "mtoc",
               "-configuration", "Release",
               "CONFIGURATION_BUILD_DIR=build/Release"
    bin.install "build/Release/mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      __attribute__((naked)) int start() {}
    EOS

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
