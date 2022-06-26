class Avimetaedit < Formula
  desc "Tool for embedding, validating, and exporting of AVI files metadata"
  homepage "https://mediaarea.net/AVIMetaEdit"
  url "https://mediaarea.net/download/binary/avimetaedit/1.0.2/AVIMetaEdit_CLI_1.0.2_GNU_FromSource.tar.bz2"
  sha256 "e0b83e17460d0202a54f637cb673a0c03460704e6c2cff0c2e34222efb2c11ca"

  livecheck do
    url "https://mediaarea.net/AVIMetaEdit/Download/Source"
    regex(/href=.*?avimetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3954f26bd43180cb106636ff5e11e5afe66b0f77ca054bcd0c2d1ef6a97125f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9e10cf64f7d87cdc85102dffea61ac546b0877896ff721a55857a2e80eb0475"
    sha256 cellar: :any_skip_relocation, monterey:       "26bde1d806ea7acbee6a436e57ac7476d069dc78c64b3700b81c5473c9f9c961"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8cbab65b9f81a1015a5550b042fcc91471b288d8e256723be694f5caf402767"
    sha256 cellar: :any_skip_relocation, catalina:       "f3b1bacfbd6b2c53421e97c37eaeee7783c1cda0e614e9a27ba34ae048bbb5c5"
    sha256 cellar: :any_skip_relocation, mojave:         "2ee42355aa90d5bc5ca8c61dc0c02274edd9c723b8a5b65595285319e9b7dda6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "323673de85bd3c8f272d5f8d0b32d34304faaa02f88c2ce44f08c697266e889e"
    sha256 cellar: :any_skip_relocation, sierra:         "75d65e8ef1ecf31ebb016aa7e1a940bdaac33042af895729a230b6ee4beab3f0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "41873fc416d070f417f1387e50515ffa099018c2f8ef27a2b8ce8b8a94b5c43f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4358ad784993160a54dde004c372a315404352d4dfad8e1dcb7e63b232332fa8"
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
