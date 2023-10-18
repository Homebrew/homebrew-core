class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https://github.com/simsong/bulk_extractor/wiki"
  url "https://github.com/simsong/bulk_extractor/releases/download/v2.0.3/bulk_extractor-2.0.3.tar.gz"
  sha256 "3967225075164f7dc5a0326e594cad4da5a49d4f091cfeaade447cc305541e32"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a02c64271ce38942dbe692e2a145e68b5e832548c7d912e3241913fe75c7d668"
    sha256 cellar: :any,                 arm64_ventura:  "59b5564f8ab61ad7fb8d6c4fba343a1444ae10c641e4664047a67322de8c25c2"
    sha256 cellar: :any,                 arm64_monterey: "0cedcba83153c8af3575d054576e40feace0356ca6d0ab08f5219ef11eb915dc"
    sha256 cellar: :any,                 arm64_big_sur:  "d103c4b7af058908703d66745fb5381f4f9a23e43679fbdeb7128074a55e939e"
    sha256 cellar: :any,                 sonoma:         "9c3eda4533bc2763c854cb61791155cc4ea41fd154d34f0f8194d4467e6444cf"
    sha256 cellar: :any,                 ventura:        "a78899f8e22c873078181c2b6d22adb29a0906e699c59a468e41e30e87a4666a"
    sha256 cellar: :any,                 monterey:       "f075b4a1369dfbe5eca7449c5a4b5510506a0394e9f74af2989ac5d7b864c354"
    sha256 cellar: :any,                 big_sur:        "f17f70d4dd78ac6360c5cf2ed17fe5d06193caebfe1a87c836c62d0e22de79ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ce4ad58e9c5d89b61973ddef9ba95ece3be3058bac97cf93c559bcdc5a4691"
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
