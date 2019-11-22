class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz"
  sha256 "000b39d5d910b867ff7e087177b470a1e26e2819920dcffd5991c33f6d480392"

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

  # Patch provided by author. See:
  # http://www.mbayer.de/html2text/faq.shtml#sect6
  patch do
    url "http://www.mbayer.de/html2text/downloads/patch-utf8-html2text-1.3.2a.diff"
    sha256 "be4e90094d2854059924cb2c59ca31a5e9e0e22d2245fa5dc0c03f604798c5d1"
  end

  def install
    inreplace "configure",
              'for i in "CC" "g++" "cc" "$CC"; do',
              'for i in "g++"; do'

    system "./configure"
    system "make", "all"

    bin.install "html2text"
    man1.install "html2text.1.gz"
    man5.install "html2textrc.5.gz"
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
