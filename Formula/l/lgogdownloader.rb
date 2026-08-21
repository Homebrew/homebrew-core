class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.18/lgogdownloader-3.18.tar.gz"
  sha256 "1974f09cb0e0cdfed536937335488548addd92e5c654f4229ac22594a22f8ae0"
  license "WTFPL"
  revision 3
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "33cbe0ecd9eb99bb077d9ed1f1da5cb0ddf9d001136f86588deb5b1fc126da4a"
    sha256 cellar: :any, arm64_sequoia: "614ecc245aa7b7981ede76536576e1d37f2a42865f06880f2908cdcefc533a18"
    sha256 cellar: :any, arm64_sonoma:  "449eb4a69d20405fef5d304abf212928a07236fc8a4f23b76858ff4ff8232df5"
    sha256 cellar: :any, sonoma:        "0897dbade424f4c690312d768f07b77af4a94cb97abf47c8ec13968b8c91dd0b"
    sha256 cellar: :any, arm64_linux:   "280d394ace8a794562a9725c9b2fe8675661c307ce78efe7f61c2a202dfa5ce5"
    sha256 cellar: :any, x86_64_linux:  "ab18a0bc52bc3d62e3a53bad413e53296d1faeba2119832681e35d224e583359"
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
