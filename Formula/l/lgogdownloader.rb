class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.17/lgogdownloader-3.17.tar.gz"
  sha256 "fefda26206ebb1e2a6d734b76f6f07977da150064141f29ed1f90450daf4e69e"
  license "WTFPL"
  revision 3
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d9bd03b6293d5fb17fabd54655dd7600fab608240b114a460754c2407fc1296"
    sha256 cellar: :any,                 arm64_sonoma:  "49fba152c84c5e9e6e516f82a9a6366ba73548871e6564b0db48c90d9e8ec328"
    sha256 cellar: :any,                 arm64_ventura: "692d0544791fa9386a7150277006a65c686521ff5075d9f0ae883c8799dc42c6"
    sha256 cellar: :any,                 sonoma:        "27cb3ba5d66a26fdacfbfc84f701958a72470e5e41e4aeef15232862b919fd55"
    sha256 cellar: :any,                 ventura:       "4e1cb55ac54c01e2796b2a153799af05ed69cc9adb2929fc82cfdedcc8b886b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b29ed9cb8fddf7bb558b03a5959f6686c74dff40609a75b7c03e27798a29f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94f0094701d17088889b2a00d2764c26b0dd0b1ff020295e4b36b996e2d65b1e"
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
