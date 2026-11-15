class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.20/lgogdownloader-3.20.tar.gz"
  sha256 "14dbbaf7d6764143444dbb5be8a53d8fdea6d8647204e05ed81f8dd5e80a4fde"
  license "WTFPL"
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8bf70da100e92a4c09baa77da04cc4c10fde6b8371d058508392cf7e5c990d3d"
    sha256 cellar: :any, arm64_tahoe:       "a86e8af5d486fa9e76deda6eaffe935ba194cfcfe50c179784d12723177e58e2"
    sha256 cellar: :any, arm64_sequoia:     "0e57ddd27354578ba087a0326b386fc9793c94361eb92f89e668da49bcb23d1d"
    sha256 cellar: :any, arm64_linux:       "9b089f82d5c9a31b81948a32267484c90fd2e59718ec4b2ea7e0a0766a675cda"
    sha256 cellar: :any, x86_64_linux:      "37ca9c6083cd7a30cbc40640b772c9d035409ca2db0413e2f2eff2f578998423"
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

  allow_network_access! :test

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
