class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.8/lgogdownloader-3.8.tar.gz"
  sha256 "2f4941f07b94f4e96557ca86f33f7d839042bbcac7535f6f9736092256d31eb5"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "deab103447abaad134f29b4f870674e1b083ac237764c76121849b9dcec6a2b7"
    sha256 cellar: :any, arm64_big_sur:  "70676c5c23a7ef12d98bf737ade96a8cb8d576c76a94cfc6e54dbfade6153ff1"
    sha256 cellar: :any, monterey:       "99b29585d3ac5429abbc20f999dc189c77526e338e9cd35533eb058a6bb3127d"
    sha256 cellar: :any, big_sur:        "67bb280ada35e19138816c4eeea533a5d89894a5dcb8ac89630bf61b5e4a108a"
    sha256 cellar: :any, catalina:       "f29b3a4de89bbb5fcb4f2d43547ef1a458a84fe4393dba1eb9137ea4c5c72a8b"
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
