class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.8/lgogdownloader-3.8.tar.gz"
  sha256 "2f4941f07b94f4e96557ca86f33f7d839042bbcac7535f6f9736092256d31eb5"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4491f2c9b0fab031877c090f1880cad45348b6fb9636b9eec834fbcb16472a56"
    sha256 cellar: :any, arm64_big_sur:  "369c84e75a36b791769eb7cb84b888fd050a5ad16f9cb010e85c4bd28a17463c"
    sha256 cellar: :any, monterey:       "9994c57133352e6eec3a7d3766745b41e07ab272441d8c705ae2a7b7ad1ee789"
    sha256 cellar: :any, big_sur:        "2fa1804d59145b057b02b32e358ba179246248d35ea69d53873e756d88ab95ff"
    sha256 cellar: :any, catalina:       "850adc82be488503d799eb2211311ab455839ca65b1e9d65b94c3ce9a8f3ec97"
    sha256 cellar: :any, mojave:         "3be4696256c82a16e5f30caaf0c9c2b7e99d465b3b96df2ff4e937ee7d3c78d7"
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
