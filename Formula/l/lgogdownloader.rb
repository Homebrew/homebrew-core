class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.12/lgogdownloader-3.12.tar.gz"
  sha256 "bf3a16c1b2ff09152f9ac52ea9b52dfc0afae799ed1b370913149cec87154529"
  license "WTFPL"
  revision 3
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe8e8ed5d4bd7ba31e36773cce8383debf1f2305e72e7c12d0ef39bf8fa3153d"
    sha256 cellar: :any,                 arm64_ventura:  "cb6111b1823b535d228869bd12bc173db2d21af8174d392b6f9e9af067181589"
    sha256 cellar: :any,                 arm64_monterey: "683e60ee04d90bb83153304cf963b3e62cbb35e55b89d17f41036ca92f2286f3"
    sha256 cellar: :any,                 sonoma:         "acad827bfb4c760d69d00a2e7ef52e5faa1f30b3d772d1848fee576e2f245473"
    sha256 cellar: :any,                 ventura:        "04c320353d11871ea6db5d97c7fefea542545edea6dc3c94b946ce6569964210"
    sha256 cellar: :any,                 monterey:       "1afb9a57e9bd6c0c298e4ee48c960b038591b9a7543cb3153276bd8915cf1d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467a7e0c47f041385487b517a574c27cb5057e114f284ca8e36b9061f7ead3e4"
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
