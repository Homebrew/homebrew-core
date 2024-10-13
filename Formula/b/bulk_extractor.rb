class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.1.1/bulk_extractor-2.1.1.tar.gz"
  sha256 "0cd57c743581a66ea94d49edac2e89210c80a2a7cc90dd254d56940b3d41b7f7"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1193b1587c9351fb7c3339252cc5962de2b0c7488cb03a77d16483227deafb49"
    sha256 cellar: :any,                 arm64_sonoma:   "d076c3c6ce906ef9136700601f34b51f720d3fc50d96ad04b578dcafa041c4d9"
    sha256 cellar: :any,                 arm64_ventura:  "90bd56b74f11074cc420af7df33a15435cd46071eabaad0c7c081b7a225b83ae"
    sha256 cellar: :any,                 arm64_monterey: "2bc48e662bd411bdaf258a34e214b00b6ee80f60904c8d846472610b798cbe67"
    sha256 cellar: :any,                 sonoma:         "fa9d38135e6b10cdfeec2a55a259a936ba7fb8468ec91ab952edef37d46fdec2"
    sha256 cellar: :any,                 ventura:        "e0d758881ed2de967484c0ab5ddf5bf815af8beed5c7cb52b5d434b1e762ee18"
    sha256 cellar: :any,                 monterey:       "c68a03087991b70830a1d0fe79fdb7886767841335aebbee7060d8faf6e7f7ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce9af040a2bc16c10f0752d4d78261753b076986d4b5a7ee420a8cca72b46cd1"
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
