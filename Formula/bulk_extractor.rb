class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.0.0/bulk_extractor-2.0.0.tar.gz"
  sha256 "6b3c7d36217dd9e374f4bb305e27cbed0eb98735b979ad0a899f80444f91c687"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "827ffd8be9d94c8d73eafee14be12527f55502fcc17177cc2388b57da50bcdef"
    sha256 cellar: :any,                 arm64_big_sur:  "0d798b0a0ab7796d05d91a2fbbda7b959d76026a1360c69e9d360ead265a3ac1"
    sha256                               monterey:       "e16b6e0276beff6059f39035e15d42a38343dba8cd157138c3a1495372e4f86f"
    sha256                               big_sur:        "4207941ab88e766e1a0fd55031585c52cea1c27ac528b7db1496a714fbeda5c4"
    sha256                               catalina:       "6acada1995761f484993f407f33014260f8c16596381172b405fe84eef206e06"
    sha256                               mojave:         "da01b2d5208c362fa10baa1a3b1d7fd018f4886eddb068107b9786c36bbff480"
    sha256                               high_sierra:    "621af8efc0671cd2905f4f077c9cfef8ac2493cf65421fb2973228c2b651c24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70e164f1f80f037e9d3026da89caad2913c2c2390a7ba69a9a161b314e75d6c9"
  end

  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
