class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.7.tar.gz"
  sha256 "984859eb2e0802cfe6fe76b1fe4b90e7354e95d52c001b6b434e0a9f5ed23bf0"
  revision 4

  bottle do
    cellar :any
    sha256 "e83c5d97b10c35f300f38b61330f777eb875e9f1c9234a14bdb9837db435fd21" => :big_sur
    sha256 "4d1ffe227ab919193c96021c9fb5ea4b161335b7ffaa0ee4bceaf3fba94280ed" => :arm64_big_sur
    sha256 "ba061ec21041d85ec77a992106630eae9e764559074947d6c8a0f875d140b20b" => :catalina
    sha256 "f76cceb5381ca392f61d5398fdb93b87f253a8256e20f554ff5fae20f2d8ef8d" => :mojave
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
    system "cmake", ".", *std_cmake_args, "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}"

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
