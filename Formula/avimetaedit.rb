class Avimetaedit < Formula
  desc "Tool for embedding, validating, and exporting of AVI files metadata"
  homepage "https://mediaarea.net/AVIMetaEdit"
  url "https://mediaarea.net/download/binary/avimetaedit/1.0.1/AVIMetaEdit_CLI_1.0.1_GNU_FromSource.tar.bz2"
  version "1.0.1"
  sha256 "3aa4ca6aed51c71684f3fd1bd3b4defc2f9e50a8bd0bdf10e55e86c8ba24aafd"

  bottle do
    cellar :any_skip_relocation
    sha256 "30a2632fe1d48e4d42fd676dcb16dda6fec0fa7de91026031f0bbe269cec4229" => :high_sierra
    sha256 "72c069835864beea09634216566cbaeac6f747368abb05aed393081aa91bf74c" => :sierra
    sha256 "d110ea050c73fe9b397a3e225bd5a41f90fad95c4fc3f5af9e0c25f5aa2f50e7" => :el_capitan
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
          "AAAAAAAAAAAAAAAAAAAAAAAABMSVNUEgAAAG1vdmkwMGRjBgAAABAQEBCAgA==".unpack("m")[0]
    (testpath/"test.avi").write avi
    assert_match "test.avi,238,AVI", shell_output("#{bin}/avimetaedit --out-tech test.avi")
  end
end
