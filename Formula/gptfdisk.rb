class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.4/gptfdisk-1.0.4.tar.gz"
  sha256 "b663391a6876f19a3cd901d862423a16e2b5ceaa2f4a3b9bb681e64b9c7ba78d"

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
