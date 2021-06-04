class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.7.tar.gz"
  sha256 "984859eb2e0802cfe6fe76b1fe4b90e7354e95d52c001b6b434e0a9f5ed23bf0"
  revision 5

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "16c65ba9c5a83ef4b68b3dfb35924a217f0cdd14f7abeb66186878293436cd94"
    sha256 cellar: :any, big_sur:       "d5c6efb4221585f32ecd462f6aa40f004ca67c0d1a7213f7a5e9a75eb9284ce8"
    sha256 cellar: :any, catalina:      "ff8b946e618395a171c842392d0f948c87140e974ab72640ee6a31b1658320bf"
    sha256 cellar: :any, mojave:        "95d4126b520376fe5dd4917d94412cdb1e0fcf0fa0e88a8494950b5a180683be"
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
