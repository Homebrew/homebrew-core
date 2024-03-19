class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.12/lgogdownloader-3.12.tar.gz"
  sha256 "bf3a16c1b2ff09152f9ac52ea9b52dfc0afae799ed1b370913149cec87154529"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72ff857c962fb4bc8b1c68197c14d875c1bf504aff2c147ea878ee3fc8fe5063"
    sha256 cellar: :any,                 arm64_ventura:  "b9d6109bb6345d09923ffc7a730fbfc520464257b05dcc7eb4e7a7b576f86111"
    sha256 cellar: :any,                 arm64_monterey: "0a3f1ca7c9d7254f6e473c326fc721110c96d9dd472a871d3160dcfb8069ea2d"
    sha256 cellar: :any,                 sonoma:         "b0e9cc48709339ebfc3afdb596ecd7229fb80fda95da2e33dd1efe8fb2e1cd07"
    sha256 cellar: :any,                 ventura:        "8c8815deb5824f0450d9ab482d5f954aacae665ee85f2ac5e9d474efc962c2a9"
    sha256 cellar: :any,                 monterey:       "0044dbe43ad4418da9072f4cb3c759205beca36ee7589624abda41ceaaccdbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f5288737914d3cad697a7d6b899b8d9df4012d2a6ec562ad0aeef88ef40469"
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
