class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.21.tar.gz"
  sha256 "c9ca13a9a7a0285214f9a18195efae57a99465392fbf05fdc4a15fceada4dedf"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b6be53767663eaf2ee6b938e485ff6fcbd03069abf4a64a7fe2e67076faa479" => :el_capitan
    sha256 "74d3ef1fff52a93936a8ae81d3dc9a6a2497cbcd5babf735d803b734d1d749fc" => :yosemite
    sha256 "418e0920e1e2e90efe573a3e617a4a6b4aa90c27e7e6843ae178a262b9f858de" => :mavericks
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
