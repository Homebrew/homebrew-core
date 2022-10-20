class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.9/lgogdownloader-3.9.tar.gz"
  sha256 "d0b3b6198e687f811294abb887257c5c28396b5af74c7f3843347bf08c68e3d0"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f90a52ab4aee796f138262a252f19e0f991ae141a87f62b4ae65dd642c7cf4c2"
    sha256 cellar: :any,                 arm64_big_sur:  "b77d59cb81ea0f93a6f409039f649bb585d6bdc78154e88670133ddbe2d7e9d8"
    sha256 cellar: :any,                 monterey:       "aefde38454409d48d8edcd6da7d0aa83f89a4fd58bef6344393e63147566ca3e"
    sha256 cellar: :any,                 big_sur:        "dcfee9a24cd8f350e412050c3396c7211143ee49ae5166cda187514727a0a4ce"
    sha256 cellar: :any,                 catalina:       "97cddd9d2c86a823b78520b74101fb356f30099c3af9dbb1df376d2006e8c1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bf9c6198e90976e11d5b26d49fc86cdc5d0817471695cb8400904bc0f0f857c"
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
