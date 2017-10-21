class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 2

  bottle do
    sha256 "bd8be8ebe8f00ce1b0d2a1d52d1c8eec1390337e78cf415414c42548558032bc" => :high_sierra
    sha256 "e2773083f3813a2ed5ecde53ff965a13ca9a995b4c9f3b2abee42162c0492f2c" => :sierra
    sha256 "cb2049ff2cd30733ec9a2456a4aefdabfa97511849d4c9b2f93de1526ee1f5ba" => :el_capitan
  end

  depends_on "boost"
  depends_on "openssl"
  depends_on "afflib" => :optional
  depends_on "exiv2" => :optional
  depends_on "libewf" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]

    (lib/"python2.7/site-packages").install Dir["python/*.py"]
  end

  test do
    input_file = testpath/"data.txt"
    input_file.write "https://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system "#{bin}/bulk_extractor", "-o", output_dir, input_file

    assert_match "https://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end
