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
    sha256 cellar: :any,                 arm64_monterey: "608cdf54c36258a9767484b0b4b438ca4a2ba6faf89b16b5cb0cd7160e00d0a5"
    sha256 cellar: :any,                 arm64_big_sur:  "8879639d2a294cbd65336ad479510d2f158099d3832460bbb4435841eeed8d51"
    sha256 cellar: :any,                 monterey:       "4f26ab65e771664b7511ed551fd2ca835900bf6cd385693629203c3fd07c0382"
    sha256 cellar: :any,                 big_sur:        "b529aea5b1beb3a6367bfc61b20ad22ccf6aec8377bfea8e02b987f0801ee852"
    sha256 cellar: :any,                 catalina:       "3129fbdeb795eca7cd7a176dd9b2db7d1eb28cec1f346c06ed3b79ff887f8475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d7b6b69d254055f9ae0b5ed2d88662a4a52bf0699b3f1173e655723ed9a2ae8"
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
