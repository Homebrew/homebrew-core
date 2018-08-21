class Dupseek < Formula
  desc "Interactive program to find and remove duplicate files"
  homepage "http://www.beautylabs.net/software/dupseek.html"
  url "http://www.beautylabs.net/software/dupseek-1.3.tgz"
  sha256 "c046118160e4757c2f8377af17df2202d6b9f2001416bfaeb9cd29a19f075d93"

  bottle do
    cellar :any_skip_relocation
    sha256 "487097be0d37b3fb4d15062dcb6a6b92dca302aa95e5a458a9e737f0e3c7efaa" => :mojave
    sha256 "fec3e17a1d9f120895a8b70df43cc366347656f2971a461e9d7251a9ea0c0927" => :high_sierra
    sha256 "c1782462d69bba5735a53dc65adb20beb42577fdb543debe9a7d19446fa16171" => :sierra
    sha256 "576106465507f9281685d12dba4409e1b409f090fc6ac1397c92b5190a5416d4" => :el_capitan
    sha256 "ec38b1caa009ca1c33efe85eb1b00cd7e37f67f3cf43b547f889e39f5be4d28a" => :yosemite
    sha256 "ff34b6c5ac5fcf84bf532008fb5fd2b2cfd9db7736854efb09e451e54b370c37" => :mavericks
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
    assert_equal "folder\\/file2", shell_output("#{bin}/dupseek -b report -f de folder").chomp
    assert_equal "folder\\/file1\nfolder\\/file2", shell_output("#{bin}/dupseek -b report -f e folder").chomp
  end
end
