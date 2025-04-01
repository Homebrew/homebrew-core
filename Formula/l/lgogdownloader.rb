class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.17/lgogdownloader-3.17.tar.gz"
  sha256 "fefda26206ebb1e2a6d734b76f6f07977da150064141f29ed1f90450daf4e69e"
  license "WTFPL"
  revision 1
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12a1dd5d5dadbb039422c6819eba6a38f645c8324eaaf513cfdb77df3c800370"
    sha256 cellar: :any,                 arm64_sonoma:  "035b84ac86616b86ff643d1e3513de9543b46635a5985719a02485aa3af46052"
    sha256 cellar: :any,                 arm64_ventura: "f68201d660c0db30f57cabd1f49bf4a5fc46fd950c3e5600723bd135d0c8cd0d"
    sha256 cellar: :any,                 sonoma:        "67e8469ccbe663088861d217f93adc6c87e44223a99064b56fca4b3282bbb8bd"
    sha256 cellar: :any,                 ventura:       "bdd2fedee3e185d8b503463056c56722d4358641711e905f1367754938b8903f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a7ebdd82aeb707aa0466d6f5cef66926b524e9df9277ca7d9629db59bf1b9de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c8e66d5e02fb115f5e5aaea7ab068385041cd2c480934bfdf82b77d8f5ff1b"
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
