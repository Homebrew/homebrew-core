class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.15/lgogdownloader-3.15.tar.gz"
  sha256 "9946558bb30b72cd5ed712e7fc425eef4b2a1fd22b5475d1a998720800cd25f0"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03f042d94ea73b39316154a49ac111eb5620c55704cf2076ec2b068045c368b7"
    sha256 cellar: :any,                 arm64_sonoma:  "c384eee02a5a785c86ff058fab34795c298fd9cdbbb6a375d59fb1f1f4d4e9c9"
    sha256 cellar: :any,                 arm64_ventura: "3e0397e020434d2b8473e351c8c4d15622fc39f9fd345332dc26f9873545d7f0"
    sha256 cellar: :any,                 sonoma:        "e29c38f06b3b2c8519d58f05438ee7c8a904545f02b02545aa4d774dd6a6715a"
    sha256 cellar: :any,                 ventura:       "bf9b8bd9761c7bfaa1ba45262e387070996eabffc001613aa7c4bf63f15374a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a21d687adb294894e88d4f2c6173aaf6ec5b293baeb548d5698c94cc0c5b1cd8"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "rhash"
  depends_on "tidy-html5"
  depends_on "tinyxml2"

  uses_from_macos "curl"

  def install
    args = %W[
      -DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}
      -DBoost_INCLUDE_DIR=#{Formula["boost"].opt_include}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
