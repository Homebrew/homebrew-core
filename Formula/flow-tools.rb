class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/archive/p/flow-tools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flow-tools/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"

  bottle do
    sha256 "b2cf9a7d6690c11dd5894bac2e38175d599341ee18dcd99a3e1185f8d8cd8995" => :catalina
    sha256 "6246a56252302b21018488ffe774cf5a203c373b1b5a4876a2d70d7d6b0cba20" => :mojave
    sha256 "be6a9b7233b78e61df362ab06916a1912b1ac197f39849081cd3d9ca4cda5c31" => :high_sierra
    sha256 "47ae55656be935936a5d3aa505f510c337818bd3c9d1a7fb028044523382dd8b" => :sierra
    sha256 "2b41c1415b50e7123c5268dce7c656aba825a16c061691ee8eaf06e39d622cec" => :el_capitan
    sha256 "0d3814f50d6bc8d06c808176bc0b6f725f429b231a21eabe49fadf6729a7d27b" => :yosemite
    sha256 "dc15779397a7f60c67b20c314b4513133c0883a5eafb3e972e744b8a70ca1060" => :mavericks
  end

  def install
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
