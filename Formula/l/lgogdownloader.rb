class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.17/lgogdownloader-3.17.tar.gz"
  sha256 "fefda26206ebb1e2a6d734b76f6f07977da150064141f29ed1f90450daf4e69e"
  license "WTFPL"
  revision 2
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b0ed64cb9c6e0ed0b58186f7dc2e883bfbab2013ce18e48a41c99d521b01614"
    sha256 cellar: :any,                 arm64_sonoma:  "573695e62f602647ce0a9a196e418a036b21b90a38a884a844f54b0189bacefe"
    sha256 cellar: :any,                 arm64_ventura: "310a33ddbd791f1797a7ddab5e199c6702775bbd26beb1d0a7d1a3a38afe7283"
    sha256 cellar: :any,                 sonoma:        "560c837b52fabc8f056c08116556430748f0ab1160e276d8d8a2140a923c83fc"
    sha256 cellar: :any,                 ventura:       "20fbfa83ad0fc270fbda1c26563939a3f335ffcfa0d3e8a8c14e9068e8d30b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db28c8aa73a8f1d3b9b32fe66a8808aba9fef32f2524d2688778c100794a482d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5461344b9818f2d8c394e7703612f9a29611a30f87158b0e486fd3a8d05d6297"
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
