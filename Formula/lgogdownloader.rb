class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.9/lgogdownloader-3.9.tar.gz"
  sha256 "d0b3b6198e687f811294abb887257c5c28396b5af74c7f3843347bf08c68e3d0"
  license "WTFPL"
  revision 3
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b7309454be5bb9ebcf3d0e8406b7f443e7abb71f2b49bdc7e08bc5aa32e3d49"
    sha256 cellar: :any,                 arm64_monterey: "cf59cafe7b2b7c27613daef308d55ccae6727cd71d2627bfdbb309bbfb244166"
    sha256 cellar: :any,                 arm64_big_sur:  "e2b28d2bde8295b152315d22445fafc85eaebad79288d32340212909f2f8c598"
    sha256 cellar: :any,                 ventura:        "0b31fd256677a4ebb84474367c3a8faaf6fee81e0d49148855daddb9707543af"
    sha256 cellar: :any,                 monterey:       "21d77cf72d41e155c7afa10bd1907c611aee00c640c6bf37c2b11dec882d179e"
    sha256 cellar: :any,                 big_sur:        "0bfd430cabfaeaa893e3a6733f7193832d61e34a991e346c0db8097347d9c181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9b780d368e3deeac346ed9e580fd9758bb3c897a5e93ff7b11f93111dedb659"
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

  uses_from_macos "curl"

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
    lastline = ""
    begin
      reader.each_line { |line| lastline = line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_equal "HTTP: Login failed", lastline.chomp
    reader.close
  end
end
