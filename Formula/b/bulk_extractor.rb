class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.1.0/bulk_extractor-2.1.0.tar.gz"
  sha256 "2ac7911e6cec65be851a538ca2b4ba8a43c560d70449af5da6e593a865f26c9b"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a03fe22ff79710a104941eefcb18257704bf6a9f98afea324abdefe06489ecd"
    sha256 cellar: :any,                 arm64_ventura:  "de246efe3f4a68125092a3f4f34ad8e48ba3e6fb612cef75a595cd95dc60f8d3"
    sha256 cellar: :any,                 arm64_monterey: "8f797364f0f97644189b9dae1b4c5d1947bad34b6d27dfc112614354d4537086"
    sha256 cellar: :any,                 sonoma:         "dd366e75d1dedeb0e11b8f5800c6bdc4aada00fe207b0b871c9427e22d9b9250"
    sha256 cellar: :any,                 ventura:        "18805a063897c5a2a95a48677793501c5c5a6f466cdcaeadaace5e74da4c19a5"
    sha256 cellar: :any,                 monterey:       "605382f84f6e2e87630806347090c36650f8412334c8a096f9faf983e52f894c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "935f739de60f8b49d000e4d3336b4415430904b818da85915e36964e6963fb47"
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
