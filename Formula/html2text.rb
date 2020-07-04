class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "https://github.com/grobian/html2text/archive/v2.0.0.tar.gz"
  sha256 "061125bfac658c6d89fa55e9519d90c5eeb3ba97b2105748ee62f3a3fa2449de"
  head "https://github.com/grobian/html2text.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d72fa6fda79a0f2b1b9f832b00105028add37a4dc3213e438683c35f3e7a0864" => :catalina
    sha256 "c8b7e49edc4b7a234546fa7ae983cefd374b43254fcd197771c6178f4b8522d3" => :mojave
    sha256 "651c7204ba8de17d552b8ccef6cb381f41bd1ca8f0f3b2577543e0daf4d92899" => :high_sierra
    sha256 "8f0adab889fb872e10fd26d57d063b9501298e11db2f996d495db0951662596f" => :sierra
    sha256 "766f16608d01f0fdf581e64e96a92d311cf96589b938cd87957d0543bb7fd1df" => :el_capitan
    sha256 "103d5c3d14bb0b13b2c6fe20f9889ea1269d276a6d294dd058c7c75ea78bf7ae" => :yosemite
    sha256 "b691a4fa679e2ae4562afe36d216b13ecaf2355167d4142bdb0f697f753eac19" => :mavericks
  end

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "all"

    bin.install "html2text"
    man1.install "html2text.1"
    man5.install "html2textrc.5"
  end

  test do
    path = testpath/"index.html"
    path.write <<~EOS
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    EOS

    output = `#{bin}/html2text #{path}`.strip
    assert_equal "Hello World", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
