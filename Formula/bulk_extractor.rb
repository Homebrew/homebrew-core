class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  license "MIT"

  stable do
    url "https://github.com/simsong/bulk_extractor/releases/download/v2.0.0/bulk_extractor-2.0.0.tar.gz"
    sha256 "6b3c7d36217dd9e374f4bb305e27cbed0eb98735b979ad0a899f80444f91c687"

    # Fix --disable-rar build. Remove in the next release.
    patch do
      url "https://github.com/simsong/bulk_extractor/commit/1a9fde225aad0fe2ffd634bdc741b4c65586297c.patch?full_index=1"
      sha256 "1c3cd2c87bae46d3163fe526def879d0e057fb700b3909362b8356be2ba2318e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0e4c5fa631e3536a5cda7b5b2a477e8dd84b622ef253012afbb82fc22cac5165"
    sha256 cellar: :any,                 arm64_monterey: "32ae091e7841c49c69054b14641d8f15b7491a756e551cb55fc869987e33456f"
    sha256 cellar: :any,                 arm64_big_sur:  "d42fc09b77698d26fe4a35f20351eb36198f00137ea2061759416e2c45c79d99"
    sha256 cellar: :any,                 ventura:        "1cd9cafb5452a5898174407298a736715c765b22bd7dab81883411d4e2f1ab68"
    sha256 cellar: :any,                 monterey:       "e68a559ff002d7db26b525160507f1378b8138b6105b8e37490d6cb51f29dda3"
    sha256 cellar: :any,                 big_sur:        "078510f412106492ddc667f09790e97bd3970e8957bf68b55f3c287c840bf1fb"
    sha256 cellar: :any,                 catalina:       "7c59c4f7040000abbd02e67eaa7d5cf26bed57105505312bbe8820357f479c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c522598f34ceb123e976e75a994f5ba2c05ac05729c025c021f6ee10a1dba0b3"
  end

  head do
    url "https://github.com/simsong/bulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

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
