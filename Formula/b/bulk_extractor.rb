class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.1.1/bulk_extractor-2.1.1.tar.gz"
  sha256 "0cd57c743581a66ea94d49edac2e89210c80a2a7cc90dd254d56940b3d41b7f7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cbca66c6d233701e44105ed24a7ac4c726ce2480592a1ef303bcc59a9e7886d"
    sha256 cellar: :any,                 arm64_ventura:  "52faa836f21c334c6733f48cc4d1d1ff87bce5bc53c69f62e8eaed685acd9201"
    sha256 cellar: :any,                 arm64_monterey: "05799a612973ea890465a7e934f7824efe5a47e41663afbe6c6e54bb879b3c06"
    sha256 cellar: :any,                 sonoma:         "3098a8bf4ab75ff8f51a44d0bf8746380d3da1540fcf85e3019678d868d34d12"
    sha256 cellar: :any,                 ventura:        "360a71e4b8ea006a59ba71e355bad2f32e695e0626ccdac58f1317e6576b0ba3"
    sha256 cellar: :any,                 monterey:       "18526411854a3ee4eece4d83defa121e8f7ffddaaeebada24fc47f4e5ad3a5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1cca868461a3cfbd8f38cb016e5db562a2152aadc01c6cecd957fed640db2b1"
  end

  head do
    url "https://github.com/simsong/bulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "re2"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    # Disable RAR to avoid problematic UnRAR license
    system "./configure", *std_configure_args, "--disable-rar", "--disable-silent-rules"
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
    system bin/"bulk_extractor", "-o", output_dir, input_file

    assert_match "https://brew.sh", (output_dir/"url.txt").read
    assert_match "(201)555-1212", (output_dir/"telephone.txt").read
  end
end
