class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.11/lgogdownloader-3.11.tar.gz"
  sha256 "d8d015cce6e002876305517367dc006c332e4d492263173b58bfe5a94b057b09"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b497d1b4be3c1738958083e5afaf775145996262030b8dc38aca4c10c4db250"
    sha256 cellar: :any,                 arm64_monterey: "4d279d442cc12b6b93c781d1c1c9923a31f31409f551dbcf6a914bba92d80b8e"
    sha256 cellar: :any,                 arm64_big_sur:  "3c407d6ea60cb155e0bc5f97725ceec39a8bb40e8a18326721b1c7d7b6984218"
    sha256 cellar: :any,                 ventura:        "d3c221ff69351f4f3c4892fec666c637b12ccad0251339b8882bc2bab1e38cc9"
    sha256 cellar: :any,                 monterey:       "5f122a520ea027f36007f5e9c3b1a1173152326e167ddd19769ea798e015bf08"
    sha256 cellar: :any,                 big_sur:        "ae5901e3070174d6d3d442d17a79008ac11e813ac5f16fccf26f576496fd2852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f39d944d8dae8b4d70555013ca58684a001a7900145a6bf1146b8e6a62d4d4"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "rhash"
  depends_on "tinyxml2"

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
      https://auth.gog.com/auth?client_id=xxx
    EOS
    writer.close
    lastline = ""
    begin
      reader.each_line { |line| lastline = line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_equal "Galaxy: Login failed", lastline.chomp
    reader.close
  end
end
