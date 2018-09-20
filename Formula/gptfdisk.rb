class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.4/gptfdisk-1.0.4.tar.gz"
  sha256 "b663391a6876f19a3cd901d862423a16e2b5ceaa2f4a3b9bb681e64b9c7ba78d"

  bottle do
    cellar :any
    sha256 "3f370d1a7e625f5d07e6c01ad4397ef9a736fe28558ef2f6d308521bc7b52100" => :mojave
    sha256 "ece7354d9226677e040f8e755f16cf51f7d2fd32ef3d761ba797bc2e19ffceb9" => :high_sierra
    sha256 "b21ce2f459eb281e2fe616c2f15908411b082d4a6c6e1952fa582768001dfa2b" => :sierra
    sha256 "8af410758295279a4f75bf0d787d47066446b7e21f78b035a5a9e5134035706c" => :el_capitan
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
