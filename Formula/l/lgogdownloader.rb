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
    sha256 cellar: :any,                 arm64_sequoia: "2cff5b6c30ab68a83840a12b5dc50027f487c5a352dcda76cec1122f9a0141dd"
    sha256 cellar: :any,                 arm64_sonoma:  "c5860d47a90d6a18ac82205c373dc4ac7f1331de4cb39e965dd6a84db3acb0db"
    sha256 cellar: :any,                 arm64_ventura: "17ce03b55a735ac9a7f91dd20bc6ba7fa82c91ce0cbcfc823162f65cfedb8472"
    sha256 cellar: :any,                 sonoma:        "50078ce1a0e7b29477bef838d636e251b8301d03ce1721735e5b075e6f8ddde5"
    sha256 cellar: :any,                 ventura:       "17c38c324c00da98136f02c07e1e0535f72789a1e02e0bdfde359bedcc0fb1a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "861a6267c937dc36257e7cd17fab62e08e3c99f9288cc5e96211d1d80466abf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce6628dc60b5f8e6acba124f88d86a1689455dd7d25df8ebce99ffd100ec649a"
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
