class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.11/lgogdownloader-3.11.tar.gz"
  sha256 "d8d015cce6e002876305517367dc006c332e4d492263173b58bfe5a94b057b09"
  license "WTFPL"
  revision 1
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7830072d3e824e1d733839fbb424246a7861a68f5ae7d5fcca7fab0c90b84d88"
    sha256 cellar: :any,                 arm64_monterey: "cf8a26d2793403c3a3ef1f4c015fe234426696c28625277a13ab1fa7481f0e04"
    sha256 cellar: :any,                 arm64_big_sur:  "31c3b37be44e4820d45ca341afe929c73dd20eb6905fbdea5f613f4a77702675"
    sha256 cellar: :any,                 ventura:        "467604c9eaf7719e91168f6a33f294bb08cc88e6f52520a81b6c2b5b064b788c"
    sha256 cellar: :any,                 monterey:       "360a96ae58a8a9e836ec4e81aa1e55576cf3af7dfc7fd13a20e852d33aff1862"
    sha256 cellar: :any,                 big_sur:        "72a0eb486ec0cd15dc92fa15a2d43e2bee6a33ed15aff2f42ff3ba55e3020282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e6035b19bc00326cce05cbfcf19d7d067cb596f6234781901285a2240337c6"
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
