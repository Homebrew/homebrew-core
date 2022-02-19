class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.9/lgogdownloader-3.9.tar.gz"
  sha256 "d0b3b6198e687f811294abb887257c5c28396b5af74c7f3843347bf08c68e3d0"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7db73c105d2b409c8cbbbd8565783238265ce8395c2bdba7ae73cb3544aca399"
    sha256 cellar: :any, arm64_big_sur:  "06c491c1378854a709d616ff3ecf337a3aece6be79053ffc260878a9e9060b5a"
    sha256 cellar: :any, monterey:       "723f700220a6a02569f8059f2821f23fa8f765c3f381494bf90d8680bde25cfe"
    sha256 cellar: :any, big_sur:        "7d3584594771dc3041df0ebcbfff164d01e806373e5e60d62aeb5cbf57b8a037"
    sha256 cellar: :any, catalina:       "2e05ee62dc093de7bc144429db2bbcdb98f00497759af349b1e4b28e80ff5221"
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
