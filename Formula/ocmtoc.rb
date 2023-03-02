class Ocmtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://github.com/acidanthera/ocmtoc"
  url "https://github.com/acidanthera/ocmtoc/archive/refs/tags/1.0.3.tar.gz"
  sha256 "9954194f28823e4b1774d2029a1d043e63b99ff31900bff2841973a63f9e916f"
  license "APSL-2.0"

  depends_on :macos

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
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
  end
end
