class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.18/lgogdownloader-3.18.tar.gz"
  sha256 "1974f09cb0e0cdfed536937335488548addd92e5c654f4229ac22594a22f8ae0"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb0b1c7a7a76080eca48c7aa24f4d9971a925aacfd012cb9e3d390513b65a7c4"
    sha256 cellar: :any,                 arm64_sequoia: "1a60b8d1b110ba497430d2320e08e948adbf2a52d64cc9cb0f33de5c8982dfb0"
    sha256 cellar: :any,                 arm64_sonoma:  "f86c404b09bf482d3ec780a596cf437c41aa0722432750ff3b3643273514de34"
    sha256 cellar: :any,                 sonoma:        "404e09a2d0eefa7393020d77951b39f1f3de16dd6d2c1fe5b521561e86246455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569a54124468f64bfde71cc9a116f04fd61713e875327b057515fae8f01c7bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e0dcd0e8a28a933c756d0e3863f7ee598485d2b9b2904217de754d0688aa76"
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
