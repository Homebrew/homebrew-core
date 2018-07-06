class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.4/gptfdisk-1.0.4.tar.gz"
  sha256 "b663391a6876f19a3cd901d862423a16e2b5ceaa2f4a3b9bb681e64b9c7ba78d"

  depends_on "popt"

  def install
    system "make", "-f", "Makefile.mac"
    sbin.install "gdisk", "cgdisk", "sgdisk", "fixparts"
    man8.install Dir["*.8"]
  end

  test do
    assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/,
                 pipe_output("#{sbin}/gdisk", "\n")

    output = pipe_output(
      "/usr/bin/hdiutil create -size 128k test.dmg " \
      "&& #{sbin}/gdisk -l test.dmg", nil, 0
    )
    assert_match /^Found valid GPT with protective MBR/, output
  end
end
