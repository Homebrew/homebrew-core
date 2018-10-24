class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 2

  bottle do
    rebuild 1
    sha256 "a5ed0825ed227f6c7dafba8f65e7de56dd14994e80e4164dfee1cc52f49a5a34" => :mojave
    sha256 "7666ded8016f96f93fcd4f8da586237b04651f518c58f467a2934a1672e3d04a" => :high_sierra
    sha256 "2de4444284b48e482818bcfe9ab0002b2d15a3bcf94ca553e086dbf9833c6dc2" => :sierra
    sha256 "d23689372ca9fff1fb214bd449c9adf6bf29a8876069a9a688bd8867af01f7a6" => :el_capitan
  end

  depends_on "boost"
  depends_on "openssl"

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
