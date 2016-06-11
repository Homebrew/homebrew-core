class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.9.tar.gz"
  sha256 "52b0daca89fcda73cde126497c8015ca823417074ba02fcff68b7acf2f45e516"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2636689f694664ada5354c81be9e7811c43f3b62a5d2b91f888466e797b569d2" => :el_capitan
    sha256 "a4f79e7c441a5865a566261d6ed8a24771d3540d9c95d420f23a5e95357abfbc" => :yosemite
    sha256 "c46928acd9e64c6d0ba070dd196e6623abe91525fff4f3c3d104a4bc6576bb07" => :mavericks
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
