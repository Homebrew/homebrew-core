class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.22.tar.gz"
  sha256 "da8d9c4f1d35d1ee355263b7f1b59c869e02fcb7cb764a695f8c730ce3dd5c2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c10251a9413e2d472d2016e030cd8fdd7e16f8e2db88bd6bc6ac5ea52a79915" => :el_capitan
    sha256 "be2506e5bec68fe4c718e0abd31cf117f01db351d8d3d43b43850c14c8dea071" => :yosemite
    sha256 "f0c43facb83035ee3a208ef24e71200e55ad2750aa82b9c53bc41eb6416970aa" => :mavericks
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
