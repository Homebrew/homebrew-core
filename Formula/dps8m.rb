class Dps8m < Formula
  desc "Simulator for the Multics dps-8/m mainframe"
  homepage "https://ringzero.wikidot.com"
  url "https://downloads.sourceforge.net/project/dps8m/Release%201.0/source.tgz"
  version "1.0"
  sha256 "51088dd91de888b918644c431eec22318640d28eb3050d9c01cd072aa7cca3c7"

  depends_on "libuv"

  def install
    # Reported 23 Jul 2017 "make dosn't create bin directory"
    # See https://sourceforge.net/p/dps8m/mailman/message/35960505/
    bin.mkpath

    system "make", "INSTALL_ROOT=#{prefix}", "install"
  end

  test do
    (testpath/"test.exp").write <<-EOS.undent
      spawn #{bin}/dps8
      expect "DPS8/M emulator (git b7a50ffc)
              Production build
              DPS8M system session id is 70486
              Please register your system at https://ringzero.wikidot.com/wiki:register
              or create the file 'serial.txt' containing the line 'sn: 0'.
              Couldn't open Devices.txt
              Unknown command: fnpload Devices.txt
              FNP telnet server port set to 6180

              DPS8M simulator V4.0-0 Beta        git commit id: c420925a"
      EOS
    assert_match "sim>", shell_output("expect -f test.exp")
  end
end
