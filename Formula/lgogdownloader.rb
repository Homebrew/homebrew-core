class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.3.tar.gz"
  sha256 "8bb7a37b48f558bddeb662ebac32796b0ae11fa2cc57a03d48b3944198e800ce"
  revision 3

  bottle do
    cellar :any
    sha256 "4cc1eaa425aaff13aa77be6be1370d41fafce047f8578c6f160412b2a51b4f43" => :mojave
    sha256 "1951f964ade47905f12ea91fd479ae8a32925b1319438ee6539d33d726aeebd4" => :high_sierra
    sha256 "8a1dbf21474f6d9957f6e43db1bb2b3023a773ae8d197a28a56bbc405190384d" => :sierra
    sha256 "faad3335e0a60363fa890c823700fb934e323226aee405587042d1fb61a55dc3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "liboauth"
  depends_on "rhash"
  depends_on "tinyxml2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
    EOS
    writer.close
    assert_equal "HTTP: Login failed", reader.read.lines.last.chomp
    reader.close
  end
end
