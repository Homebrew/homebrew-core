class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.16/lgogdownloader-3.16.tar.gz"
  sha256 "24b005bf3caf00ebc8c603251f5689d66098f66dd37bdf399836289064cb0c9f"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afe2bf9f7c90a2f818f03ed442f95b03a95c3bd4e087f509a815fe0e483f7687"
    sha256 cellar: :any,                 arm64_sonoma:  "8e7820c74647cac8927100beb0cb1dd95c93d3a0ee9d86c1cd1c718c60880500"
    sha256 cellar: :any,                 arm64_ventura: "0a7b30cd7b0f41bf95532d02760fb7963748253b071033e3d6827194112946eb"
    sha256 cellar: :any,                 sonoma:        "109977b412ccd85b46c18d5040d0f14a26bba7b0cf2968c3ac409db3bd8dd2dd"
    sha256 cellar: :any,                 ventura:       "7bcc37e842c4e86dc72c35a40c3626476eaf2331d01df07fb0a7b9129a811bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5cabbb15fd9fb2d025ecf398ddcd70140c1e6014b76a78c6ae62b42f3ae8765"
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
