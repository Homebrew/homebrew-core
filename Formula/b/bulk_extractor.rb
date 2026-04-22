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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce16972463075eb40a46aff2cec48868513aeeb181a67fbdf41ead522d06d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d584ce493285ccd23882534b8707dc2635a97ff4890fb3c84051a2544b9eaf91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5d8eec3919cad2196afcabb07b9f92d04de7e46d908887aae54cdb655a57fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd2032241f7acb78ae73beb4254a1c9a55ad60b88568b52e260859ae01eacc41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63def3013392e1b55add767f77b6722108804e57ccf91090ea82f3cff28292aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a7347706e0ec70fd5db04d47420c392ff30a7f9da887cb8f66c56c86ba7c6b"
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

  on_linux do
    depends_on "openssl@3" # uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
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
