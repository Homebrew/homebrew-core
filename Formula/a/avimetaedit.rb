class Avimetaedit < Formula
  desc "Tool for embedding, validating, and exporting of AVI files metadata"
  homepage "https://mediaarea.net/AVIMetaEdit"
  url "https://mediaarea.net/download/binary/avimetaedit/1.0.2/AVIMetaEdit_CLI_1.0.2_GNU_FromSource.tar.bz2"
  sha256 "e0b83e17460d0202a54f637cb673a0c03460704e6c2cff0c2e34222efb2c11ca"
  license "CC0-1.0"

  livecheck do
    url "https://mediaarea.net/AVIMetaEdit/Download/Source"
    regex(/href=.*?avimetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a3354d0e2c79d26a44be8eaa5297b6d3142b8a2754b2e9b4103a521f0209bcc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d4a0e40875df5de8808e670967741dfbf1587d033d3262754e99ab43213f63d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4f66c36f77f301329187605c19b423905190a8856052516b6921dcf766bf1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27712b47badd939a9d42753a26584e98829ade7692a630944a805b649148e84f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3954f26bd43180cb106636ff5e11e5afe66b0f77ca054bcd0c2d1ef6a97125f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9e10cf64f7d87cdc85102dffea61ac546b0877896ff721a55857a2e80eb0475"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f8699ec5d2e344e137f5571ecfb345f9bfdfdbad88d86f39e88f555d8018d0c"
    sha256 cellar: :any_skip_relocation, ventura:        "8e46ebb28eed64365f6e9e8b460aa3055216efde63561aaa8ef8f03bba8ee365"
    sha256 cellar: :any_skip_relocation, monterey:       "26bde1d806ea7acbee6a436e57ac7476d069dc78c64b3700b81c5473c9f9c961"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8cbab65b9f81a1015a5550b042fcc91471b288d8e256723be694f5caf402767"
    sha256 cellar: :any_skip_relocation, catalina:       "f3b1bacfbd6b2c53421e97c37eaeee7783c1cda0e614e9a27ba34ae048bbb5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "01314c71d02ebe43ef66968361d932ca27bcbfe37a498a6b8881812bd0b86427"
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
