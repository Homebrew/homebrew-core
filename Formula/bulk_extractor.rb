class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.5.5.tar.gz"
  sha256 "297a57808c12b81b8e0d82222cf57245ad988804ab467eb0a70cf8669594e8ed"
  revision 3

  bottle do
    sha256 "6acada1995761f484993f407f33014260f8c16596381172b405fe84eef206e06" => :catalina
    sha256 "da01b2d5208c362fa10baa1a3b1d7fd018f4886eddb068107b9786c36bbff480" => :mojave
    sha256 "621af8efc0671cd2905f4f077c9cfef8ac2493cf65421fb2973228c2b651c24e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  # Upstream commits for OpenSSL 1.1 compatibility in dfxm:
  # https://github.com/simsong/dfxml/commits/master/src/hash_t.h
  # Three commits are picked:
  #   - https://github.com/simsong/dfxml/commit/8198685d
  #   - https://github.com/simsong/dfxml/commit/f2482de7
  #   - https://github.com/simsong/dfxml/commit/c3122462
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/78bb67a8/bulk_extractor/openssl-1.1.diff"
    sha256 "996fd9b3a8d1d77a1b22f2dbb9d0e5c501298d2fd95ad84a7ea3234d51e3ebe2"
  end

  def install
    # Source contains to copies of dfxml, keep them in sync
    # (because of the patch). Remove in next version.
    rm_rf "plugins/dfxml"
    cp_r "src/dfxml", "plugins"

    # Regenerate configure after applying the patch.
    # Remove in next version.
    system "autoreconf", "-f"

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
