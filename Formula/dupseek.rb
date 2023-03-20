class Dupseek < Formula
  desc "Interactive program to find and remove duplicate files"
  homepage "http://www.beautylabs.net/software/dupseek.html"
  url "http://www.beautylabs.net/software/dupseek-1.3.tgz"
  sha256 "c046118160e4757c2f8377af17df2202d6b9f2001416bfaeb9cd29a19f075d93"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?dupseek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "027dd10f7bd0d393e01a0ea75e43a09428dd2d4aa4c18d2178b77d4a59229f96"
  end

  def install
    bin.install "dupseek"
    doc.install %w[changelog.txt doc.txt copyright credits.txt]
  end

  test do
    mkdir "folder"
    touch "folder/file1"
    assert_equal "", shell_output("#{bin}/dupseek -b report -f de folder").chomp
    touch "folder/file2"
    assert_match %r{^folder\\/file[12]$}, shell_output("#{bin}/dupseek -b report -f de folder").chomp
    assert_equal "folder\\/file1\nfolder\\/file2", shell_output("#{bin}/dupseek -b report -f e folder | sort").chomp
  end
end
