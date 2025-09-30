class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.17/lgogdownloader-3.17.tar.gz"
  sha256 "fefda26206ebb1e2a6d734b76f6f07977da150064141f29ed1f90450daf4e69e"
  license "WTFPL"
  revision 4
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6551f55711cac8ccd20e6f275f8bb318e1a67f46aa6831c5c30b54f4f3ccb31f"
    sha256 cellar: :any,                 arm64_sequoia: "2dba206d8cc2b6f97070944d8c08bcba513343937a048b35c5ec1e5b609d690f"
    sha256 cellar: :any,                 arm64_sonoma:  "2b31964b42a64a2fa5505ca2855f9f469b9620a289e5713184d05b0e4fddda05"
    sha256 cellar: :any,                 arm64_ventura: "b546042fd54e6822437dedc892b8e39192f90eb79bc95b5778cd3fc2ac2a49c0"
    sha256 cellar: :any,                 sonoma:        "e99fc18b427c0e6c7cbaa4b13b7cd28ed131184e21979769b5d12d63832bd062"
    sha256 cellar: :any,                 ventura:       "182e0b13ccba06d61ad71d70d2fcbe77dc81d9fd4a52977145e61b9acd061b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0d20f3679739fcc6d5c50ee73e3fef0b96acd6eef67d0917f016f575a5f7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2294e37c0cf1a5b24ab58d70e316ee3737d4fa439f886d2fe8150a7630c6b7ee"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/Sude-/lgogdownloader/pull/296
  patch do
    url "https://github.com/Sude-/lgogdownloader/commit/7ba719a7a53d6025cd82f8b1c86e765285ed802b.patch?full_index=1"
    sha256 "189b1f589b887d3086a42e96b93fe5b1b70c875091e98136c6f0ceff48c879e9"
  end

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
