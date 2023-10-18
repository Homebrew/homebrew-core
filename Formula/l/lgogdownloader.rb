class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.11/lgogdownloader-3.11.tar.gz"
  sha256 "d8d015cce6e002876305517367dc006c332e4d492263173b58bfe5a94b057b09"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11c4df1d1bac27c3d5a4f4089c2845a479081a5e7676219d4588607c9bcbeaa8"
    sha256 cellar: :any,                 arm64_ventura:  "1b9940bd11ba791f39d4836423124bc3d817c8711102fcdeebde9fe19d4bd39e"
    sha256 cellar: :any,                 arm64_monterey: "cdd02f78418f68f0538c18a2f5e88cd341db4976ff37e81ba0e68e8beb28fcc7"
    sha256 cellar: :any,                 arm64_big_sur:  "13d37c9e5b87f06a9c1fc59732adf3143d14af10915735e44bf446720d48ef0c"
    sha256 cellar: :any,                 sonoma:         "5f14cf3332c441467cc3f207104b16b2747345406c94b4ef7a58300368811374"
    sha256 cellar: :any,                 ventura:        "64e2d38ace1a2b368f57e878d29c0d6f3070c63cdd88976214987bcc9def3409"
    sha256 cellar: :any,                 monterey:       "ef717cffced5d634ad7a1f898efc203ed5113c14f6746665a657f533126ced7f"
    sha256 cellar: :any,                 big_sur:        "5af4bd2a87633d351340e80bb07374b5a5f7d662a327b71123c2ba77c8f297e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c4c04f52e8cefa79bf839834aa3d0f7cd4b21b0d2eecc76d7fb1a079c40b89"
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
