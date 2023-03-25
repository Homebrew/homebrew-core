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
    sha256 cellar: :any,                 arm64_ventura:  "d279f6f6081ee152d98c913c68d3fb170bad072f9e86421a29bfe12abbf07faf"
    sha256 cellar: :any,                 arm64_monterey: "7e95d0d0f2374b6644757adaa1e15ce3fd07d8318ab92e85716e7f30c20e972a"
    sha256 cellar: :any,                 arm64_big_sur:  "6b7eac0ab1909e6aff662fc795496fc900299494c2a5c2fbcf0b47cf9367ef33"
    sha256 cellar: :any,                 ventura:        "21c4c8c065b9cc591b9c64aaf7e89dc73f97b46b45f96c36c5cd0ca7da46571f"
    sha256 cellar: :any,                 monterey:       "885033cd23ecad2758386d55887a5db8244c71b0173e5a30fa93a4cfc54e0dd2"
    sha256 cellar: :any,                 big_sur:        "37d7cce5462b3bb759e551440cbf26d00391f48112c8202612b2de957f0910a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8bdf0e04dd32e770f41ce2cf8b00c4f38c467658865d4ba51ea59d420fab54c"
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
