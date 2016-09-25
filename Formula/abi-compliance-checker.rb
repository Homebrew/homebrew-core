class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.23.tar.gz"
  sha256 "5d1a66e12b654798a09bdc087bb523bb38dd52bc6a212d604c18b547eb1ca2b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbccd1f176823b3003b863e0c7a5a9a890d4a1e691ae0a9f8dd0972c7dc4a6dc" => :sierra
    sha256 "de51254b07fbbf3b235dc0b3739282eca049a9a2fec09c07c8341afd85a029dc" => :el_capitan
    sha256 "9449c8dd5e1f0b768aa84a6aeaa26478595ecdddcbb6a279861ea488303a7da7" => :yosemite
    sha256 "f4a6b2172826629e6fa9c3d16f7b334e3aa57646a843717ea7020428b042186c" => :mavericks
  end

  depends_on "ctags"
  depends_on "gcc" => :run

  def install
    system "perl", "Makefile.pl", "-install", "--prefix=#{prefix}"
    rm bin/"abi-compliance-checker.cmd"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <version>1.0</version>
      <headers>#{Formula["ctags"].include}</headers>
      <libs>#{Formula["ctags"].lib}</libs>
    EOS
    gcc_suffix = Formula["gcc"].version.to_s.slice(/\d/)
    system bin/"abi-compliance-checker", "-cross-gcc", "gcc-" + gcc_suffix,
                                         "-lib", "ctags",
                                         "-old", testpath/"test.xml",
                                         "-new", testpath/"test.xml"
  end
end
