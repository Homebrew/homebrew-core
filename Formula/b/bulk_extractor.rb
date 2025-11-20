class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.1.1/bulk_extractor-2.1.1.tar.gz"
  sha256 "0cd57c743581a66ea94d49edac2e89210c80a2a7cc90dd254d56940b3d41b7f7"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28112f82cc9e0e627462d3a4b5d882ac36e00ca7367a9a367dc15b5d7dfc95c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a31d530c9667f15046ad54b617056fe121a9eec4f7b24749207b8b6e84f9083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d670cf96b00bf5497c822bf2b7f0aef8c1b23cec45692a37bb2c61e3fedc0c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a2707abfb8d0b3cf9744d495661c47a3ff3fc0bf16cbbc09311ccd462dc54c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3f3290fda284e7b8e04d5c64ee3a06b06048b37c1f7399a3374ac033c3d5f74"
    sha256 cellar: :any_skip_relocation, ventura:       "f85d235e221af43b55ab85384aa5f4e3799d5cd73c8bf54e41cf1d0cae93464f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd712b046cc8a9d3b6707582ab3a2d309b71c534617828cb8eca95e8a56905f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "624fbdcd4889624e1c1da350a4433335234d25bf861686bcf4736e5f4315ee0b"
  end

  head do
    url "https://github.com/simsong/bulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  # Not actually used at runtime, but required at build-time
  # due to a stray `RE2::` reference.
  depends_on "re2" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # uses CommonCrypto on macOS
  end

  def install
    # Avoid overlinkage with abseil and re2.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?
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
