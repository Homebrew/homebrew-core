class Lst < Formula
  desc "Save snippets of information quickly through the command line"
  homepage "https://liszt.readthedocs.io"
  url "https://github.com/scamacho23/homebrew-liszt/archive/v1.1.7.tar.gz"
  sha256 "01b9256151079f4c3727a5ce7b179a9ad7733180d966a112bcbeac6321805aea"
  license "GNU GPL-3.0"
  version "1.1.7"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "lst"
  end

  test do
    system "lst " "-ch " "default"
    expected = <<~EOS
      default
    EOS
 
    assert_match expected, shell_output("#{bin}/lst -n")
  end
end
