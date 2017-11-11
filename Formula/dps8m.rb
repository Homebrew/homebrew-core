class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com"
  url "https://downloads.sourceforge.net/project/dps8m/Release%201.0/source.tgz"
  version "1.0"
  sha256 "51088dd91de888b918644c431eec22318640d28eb3050d9c01cd072aa7cca3c7"

  depends_on "libuv"

  def install
    bin.mkpath
    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/dps8
      set timeout 5
      expect {
        timeout { exit 1 }
        "sim>"
      }
      send "help\r"
      expect {
        timeout { exit 2 }
        "SKIPBOOT"
      }
      send "q\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    assert_equal "Goodbye", shell_output("expect -f test.exp").lines.last.chomp
  end
end
