class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.19/lgogdownloader-3.19.tar.gz"
  sha256 "0fd3622f1cee4627048aafbbebd17dc38fd3ddb220c979e4a118eeab2cc665d4"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "47028108297724eb3289612cc4a51b1e435fa1dd85053a5f7a20fbd47bfac21b"
    sha256 cellar: :any, arm64_tahoe:       "d51953f9f373e941a492932d0cc107f9714bd234335ae5dd8384ed177e4b96fa"
    sha256 cellar: :any, arm64_sequoia:     "2049eaa34dbbabeb299453b901f8675b1ea3261e29d20d6a8a60977de7e678a7"
    sha256 cellar: :any, arm64_linux:       "018aacdff45c62d39da2c28cefed81145ecae59ed1a1eff25f0b1ec92be2e1d4"
    sha256 cellar: :any, x86_64_linux:      "f5e45b068e0b6d73c87c02afa51ab8c06df0e802eec9e26fdfef9060e70766df"
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
      -DJSONCPP_INCLUDE_DIR=#{formula_opt_include("jsoncpp")}
      -DBoost_INCLUDE_DIR=#{formula_opt_include("boost")}
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
