class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.18/lgogdownloader-3.18.tar.gz"
  sha256 "1974f09cb0e0cdfed536937335488548addd92e5c654f4229ac22594a22f8ae0"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fe96a9615c0a202089916f23840e7f42a470bb4cefd2fc8f7f479efb07a2f42"
    sha256 cellar: :any,                 arm64_sequoia: "767059314331b099bb3e36828786cfbb70111f554fd98211276dbb58f0e87a39"
    sha256 cellar: :any,                 arm64_sonoma:  "206ba19cf3a71d379a02612c6022c760c1e4f146056de4957bc751a996b8842c"
    sha256 cellar: :any,                 sonoma:        "b254dc0f83eb097b2b217afd548ea468d15aef35843fceb97d69c2add5165481"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1a01aa5ec328d12d2fd5313530727b17331cc9e185fdb960a5c57b81e984ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771b4f2db2f1f6fedab5297c4b7fdb4778bf21bd48ef97f1da73346f7fd4f92c"
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
