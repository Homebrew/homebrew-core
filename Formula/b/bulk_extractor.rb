class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.2.0/bulk_extractor-2.2.0.tar.gz"
  sha256 "b9e15d40d711aa43590e1bf1a25d30943e3bad8371281d7c80d3803a6f34c268"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b24559ddfbf33739ec78e8a3bf7186b3b79c5fff6005410518df98a013e3f1e2"
    sha256 cellar: :any, arm64_sequoia: "ce0e850624d6db32edc9f7fffdf6ff713fdb7e86cc5489e5166540fdb6566bcb"
    sha256 cellar: :any, arm64_sonoma:  "1aeef957b72026510d04879bde39d553be64d8eaeca55f42e9f4b894e8ca5064"
    sha256 cellar: :any, sonoma:        "4f601e0442bef357c5c75f1e780bc9a7ef652965320b532747c98aa7858ced7f"
    sha256 cellar: :any, arm64_linux:   "e2ad92284668d2422db43f57e88adfa6ccdc4ee07a91da8c46d18a1e9bd3bda0"
    sha256 cellar: :any, x86_64_linux:  "b1adc306b7efaaecfa6130c975050cec0d5efb06222922e8e8dfefc70bd57ceb"
  end

  head do
    url "https://github.com/simsong/bulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "abseil" => :build # only needed for `re2.pc`
  depends_on "pkgconf" => :build
  depends_on "re2"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@4" # uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  def install
    # Avoid overlinkage with abseil.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?
    system "./bootstrap.sh" if build.head?
    # Disable RAR to avoid problematic UnRAR license
    system "./configure", *std_configure_args, "--disable-rar", "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare/"doc").install Dir["doc/*.{html,txt,pdf}"]
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
