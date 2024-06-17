class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.14/lgogdownloader-3.14.tar.gz"
  sha256 "2629c54e2549881cdd155b4f89b472c62617db7a9cfe6b68dbcb1753080b1448"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a9de6ed7c7ec77d44b813cde0c83fc573f3dbb0d8be891b56ffc3397b1101a02"
    sha256 cellar: :any,                 arm64_ventura:  "a3799f06e0ad3d204aed0e115063b833e07b559f91adb40c5ff320f80ebdce51"
    sha256 cellar: :any,                 arm64_monterey: "49765ce12ddffec3053a7e78534ac991528e60be0e04f7cbdadb70c176c2aab6"
    sha256 cellar: :any,                 sonoma:         "064e4a05acb3dbe9a70fa9ceec8a27934e6f6cced8f6b707f50440b05f369c53"
    sha256 cellar: :any,                 ventura:        "26730cd36bb8305c9c1ad99aedba7cb39f92a0ddf6b1e2de8259687246449ad9"
    sha256 cellar: :any,                 monterey:       "6f980ab4fbfc71614ac52e62d2b51e97ecf46096284af0c13bee4e781cf09d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e222f35f393e64335cd3d963c299729569047f47b12a6b56b620e02b2447077"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
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
