class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.3.tar.gz"
  sha256 "8bb7a37b48f558bddeb662ebac32796b0ae11fa2cc57a03d48b3944198e800ce"

  bottle do
    cellar :any
    sha256 "99f22460fa9b209cd94e4aeb9d387dc6ad14089e7576cf6a00829be6dc29feb7" => :high_sierra
    sha256 "f4217a423e5cb8ea853573e9c21dd41c7c177c5ed29fd762c069c18daf0e5595" => :sierra
    sha256 "8cac52af514efb33ebd3e239aed25c9a3db40920e3607f8830ace559f72ebb93" => :el_capitan
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
