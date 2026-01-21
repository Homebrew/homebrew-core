class DapicoTools < Formula
  desc "macOS USB tools for RP2040-based boards"
  homepage "https://github.com/nanoscopic/dapico-tools"
  url "https://github.com/nanoscopic/dapico-tools/archive/refs/tags/0.1.5.tar.gz"
  sha256 "bda2f6b18a429a2d3a6b54801542688b2fabf5fbb0bcd6b27af92dee8ea9670c"
  license "BSD-3-Clause"
  depends_on "cmake" => :build
  depends_on :macos

  resource "test-elf" do
    url "https://dryark.com/test.elf"
    sha256 "795868c4be0775eadc3da27c82d6b966328c0be0718eee198b7f66c7c40d09b8"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/dapico-reboot", "--help"
    system "#{bin}/dapico-load", "--help"
    testpath.install resource("test-elf")
    output = shell_output("#{bin}/dapico-load --dryrun #{testpath}/test.elf 2>&1")
    puts "dapico-load output:\n#{output}"
    assert_match "write RAM 0x20000000 (33500 bytes", output
    assert_match "write RAM 0x200082dc (5832 bytes", output
    assert_match "execute at 0x200001e9", output
  end
end
