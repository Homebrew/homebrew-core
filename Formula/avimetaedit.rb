class Avimetaedit < Formula
  desc "Tool for embedding, validating, and exporting of AVI files metadata"
  homepage "https://mediaarea.net/AVIMetaEdit"
  url "https://mediaarea.net/download/binary/avimetaedit/1.0.2/AVIMetaEdit_CLI_1.0.2_GNU_FromSource.tar.bz2"
  version "1.0.2"
  sha256 "e0b83e17460d0202a54f637cb673a0c03460704e6c2cff0c2e34222efb2c11ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3b1bacfbd6b2c53421e97c37eaeee7783c1cda0e614e9a27ba34ae048bbb5c5" => :catalina
    sha256 "2ee42355aa90d5bc5ca8c61dc0c02274edd9c723b8a5b65595285319e9b7dda6" => :mojave
    sha256 "323673de85bd3c8f272d5f8d0b32d34304faaa02f88c2ce44f08c697266e889e" => :high_sierra
    sha256 "75d65e8ef1ecf31ebb016aa7e1a940bdaac33042af895729a230b6ee4beab3f0" => :sierra
    sha256 "41873fc416d070f417f1387e50515ffa099018c2f8ef27a2b8ce8b8a94b5c43f" => :el_capitan
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    avi = "UklGRuYAAABBVkkgTElTVMAAAABoZHJsYXZpaDgAAABAnAAAlgAAAAAAAAAQCQAAAQAAAAAAAAABAAAAAAAQAA" \
          "IAAAACAAAAAAAAAAAAAAAAAAAAAAAAAExJU1R0AAAAc3RybHN0cmg4AAAAdmlkc0k0MjAAAAAAAAAAAAAAAAAB" \
          "AAAAGQAAAAAAAAABAAAABgAAAP////8AAAAAAAAAAAIAAgBzdHJmKAAAACgAAAACAAAAAgAAAAEADABJNDIwBg" \
          "AAAAAAAAAAAAAAAAAAAAAAAABMSVNUEgAAAG1vdmkwMGRjBgAAABAQEBCAgA==".unpack1("m")
    (testpath/"test.avi").write avi
    assert_match "test.avi,238,AVI", shell_output("#{bin}/avimetaedit --out-tech test.avi")
  end
end
