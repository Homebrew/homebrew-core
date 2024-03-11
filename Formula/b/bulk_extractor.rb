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
    sha256 cellar: :any,                 arm64_sonoma:   "24e76db172c2903182037871674f0a390ef28475264e04cfa8474234375e37bd"
    sha256 cellar: :any,                 arm64_ventura:  "5897018830b5d9d714a6edd12f4ea98a0938e7c97c3eaed2318f15781a349cdf"
    sha256 cellar: :any,                 arm64_monterey: "96682a58d28122673737784502ec0690b183c9851022378083aa05d097ac465b"
    sha256 cellar: :any,                 sonoma:         "54384cff4786fe0c9ca7ec24de8f91636b75414e8829fd92d0fb9a1b7d546688"
    sha256 cellar: :any,                 ventura:        "4583c5e2bb3a278ecaf642e971bd1bb61bae870efa59569e0aa52497fe37a102"
    sha256 cellar: :any,                 monterey:       "f312339220d7155b489c5be0ebaa8aab203f8f3c7c5f86339a44f5b916325501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d2b8a41efdd34797ba504c554f929392fc5a3a906741b695d68b79392a64c0b"
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
