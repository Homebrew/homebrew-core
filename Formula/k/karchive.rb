class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.30/karchive-6.30.0.tar.xz"
  sha256 "4cf89d91e429d2ece3110e78f7ef7011952b0412cb15011329516b46f21e98e2"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7fb7963ee37c3876f012072af1ab5a11e88bf22f7778ba6b8fb37dd4250a02b4"
    sha256 cellar: :any, arm64_tahoe:       "fa237b5d0ba712ace0efe493567fbd632cf376822c1346913b07fd6b40d3050c"
    sha256 cellar: :any, arm64_sequoia:     "7cb60121e1a6ce869372767228c55135747a0abee8e4d6bbcbc310496069968a"
    sha256 cellar: :any, arm64_sonoma:      "e770c16597749715154be7f1cc6e3a85f8a8034403c406f50530d2c6c473b639"
    sha256 cellar: :any, arm64_linux:       "931893232f12273a4a9ee502b4fbac478736de5e0dba544ea11502f334224d66"
    sha256 cellar: :any, x86_64_linux:      "4dbeba4ac4e94d835c43722d4919f7b446557b8c0fefa268659237712a671a62"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "openssl@3"
  depends_on "qtbase"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    examples = %w[
      bzip2gzip
      helloworld
      tarlocalfiles
      unzipper
    ]

    examples.each do |example|
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~CMAKE
        cmake_minimum_required(VERSION 4.0)
        \\0
      CMAKE

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_path_exists testpath/"hello.zip"

    system "unzipper/unzipper", "hello.zip"
    assert_path_exists testpath/"world"

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_path_exists testpath/"myFiles.tar.gz"
  end
end
