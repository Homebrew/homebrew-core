class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.14/lgogdownloader-3.14.tar.gz"
  sha256 "2629c54e2549881cdd155b4f89b472c62617db7a9cfe6b68dbcb1753080b1448"
  license "WTFPL"
  revision 1
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25c97efdcc6961e73c701178e8aa50451115ed7d462cdb6498da9b506b5ed390"
    sha256 cellar: :any,                 arm64_ventura:  "474802400caa809375acc05668b32401d74be82f291e8a266c0a50c620570f2e"
    sha256 cellar: :any,                 arm64_monterey: "10eb0aa537b2e16dedf0734c20a2dbae485646e96f9a7ee697fa9de915ccfa3a"
    sha256 cellar: :any,                 sonoma:         "fa633a2f44babf70e92ee65de454a369d68a56133dce5ac87e259c44f7c354b9"
    sha256 cellar: :any,                 ventura:        "12375781b95e0e685948e0178a7e2812811bd42cf983afc486508b75234dcbd8"
    sha256 cellar: :any,                 monterey:       "14e6447257e9ffad4b8b8118eaffe3c4bb8ce208990c84450b99963c7edfca22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9fedf8de445cd71b34b801877806837550ccc54a84f3eaefa95cd5b27672d3c"
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
