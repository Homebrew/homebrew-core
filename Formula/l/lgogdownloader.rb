class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.18/lgogdownloader-3.18.tar.gz"
  sha256 "1974f09cb0e0cdfed536937335488548addd92e5c654f4229ac22594a22f8ae0"
  license "WTFPL"
  revision 1
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42e874eee147a72ce96a7326b5d3dae82cec90156e5c10d7f204c69f1a2842a3"
    sha256 cellar: :any,                 arm64_sequoia: "b4b305ec16cafc2a94813472c8e8f63c0e2a199787f809bc0179bd29e98aba54"
    sha256 cellar: :any,                 arm64_sonoma:  "f951ba8180d50c679a0ba14c0674d873e90a7d30208ffc348b97b9a30ed9f8c1"
    sha256 cellar: :any,                 sonoma:        "4242df1de313063ff369a3da546a6d8f9933d152a1e6a26c2d2a80c6fd343313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3caac3f84d42ebe9c273bfab66f15d8899f405f9d273b7be318f96e430d5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe52df8fafbe4ded3f94210ac2014de0cb41197a98d2da988ed1638b724be24"
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
