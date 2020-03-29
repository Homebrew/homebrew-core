class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.5/gptfdisk-1.0.5.tar.gz"
  sha256 "0e7d3987cd0488ecaf4b48761bc97f40b1dc089e5ff53c4b37abe30bc67dcb2f"

  bottle do
    cellar :any
    sha256 "7764d3c435876ddc2d8c2fc67ac033f1fae3343967844254deaa3854adf62285" => :catalina
    sha256 "7764d3c435876ddc2d8c2fc67ac033f1fae3343967844254deaa3854adf62285" => :mojave
    sha256 "d68f15fdff5ea9385e68129a209c8d2de1f9525a114637e8b361caf06bf4e482" => :high_sierra
  end

  depends_on "popt"

  def install
    system "make", "-f", "Makefile.mac"
    %w[cgdisk fixparts gdisk sgdisk].each do |program|
      bin.install program
      man8.install "#{program}.8"
    end
  end

  test do
    system "hdiutil", "create", "-size", "128k", "test.dmg"
    output = shell_output("#{bin}/gdisk -l test.dmg")
    assert_match "Found valid GPT with protective MBR", output
  end
end
