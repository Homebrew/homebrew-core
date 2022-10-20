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
    sha256 cellar: :any,                 arm64_monterey: "3853437885b3ddebe96ff0fdf82cc51bb463475896773a0bc187c3eee797df64"
    sha256 cellar: :any,                 arm64_big_sur:  "86ea36c73ad1de83fdfd03e3ac0d009eef3717a06ba371405719e7bdaab4a23e"
    sha256                               monterey:       "41288b59b588eb7d4d3e0aaaaef02d90bef22525b4baaa652df2fc4974b9cef8"
    sha256                               big_sur:        "35b5eaae1670fc6dea617ddb76d703aafe336097ae1646e2ec6f925f85d7803b"
    sha256                               catalina:       "13f47b8410b0f8af8bf7a65ea5dde4790051c295854552fdcebaceb3ed49a510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89721d67c9460edc181f54c0c92f3dd56dd0f70cba83356b9cc3dffecb5c995"
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
