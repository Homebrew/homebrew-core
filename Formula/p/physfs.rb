class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://github.com/icculus/physfs/archive/refs/tags/release-3.2.0.tar.gz"
  sha256 "1991500eaeb8d5325e3a8361847ff3bf8e03ec89252b7915e1f25b3f8ab5d560"
  license "Zlib"
  head "https://github.com/icculus/physfs.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0944ba1768fe03b03b2705b401890c25dccd9598ef9a0113796b95b6aeebdb49"
    sha256 cellar: :any,                 arm64_sequoia:  "e6b0663f9c6fd2b671825e510c705706dfccc018571c20e689ef082d5b701fdb"
    sha256 cellar: :any,                 arm64_sonoma:   "7556de6af5b763d6ce5fbb4e56acd432aefd2752a8bd27b38377de64f7f0ffc6"
    sha256 cellar: :any,                 arm64_ventura:  "033ca59ee6e8065927dc2c9e9161c5c673cc479d6d5991fe797c7677e474617d"
    sha256 cellar: :any,                 arm64_monterey: "b46aa5368cc2331f6b7f9abd675e40ae06fce1c0864bcf3ded3ebabf1bbc4756"
    sha256 cellar: :any,                 arm64_big_sur:  "f627a4cae2e3476f4ed357f265d522a06a1b5d3c51064dcce1dafb0c625d8904"
    sha256 cellar: :any,                 sonoma:         "57d1132edf37fbffbd596c962efb07fbf60a038874c6fbaab3280cad289ddd24"
    sha256 cellar: :any,                 ventura:        "7cbc056544fd8a02a9e85931cf7a7e9fe9387b0c41ad485a8d0bc29a217d11a9"
    sha256 cellar: :any,                 monterey:       "8d81d2499641e8c30ccc9bcbd2d26ed59f173a4b438b64a554b8c9af62b94fec"
    sha256 cellar: :any,                 big_sur:        "6a28290a9fc698ba51ebcab233cabc708c5a611f74d94f99dc00a8348032438c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "16a3df7f2d1830b906dc58a405ca2754d444887806397a796739b848270355f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd94c275f27747d40f025ed1ad50fd8a50e39853a8ca0be664f316e06fa7983f"
  end

  depends_on "cmake" => :build

  uses_from_macos "zip" => :test

  on_linux do
    depends_on "readline"
  end

  def install
    # Workaround for CMake 4.0+. Remove on next release.
    if build.stable?
      odie "Remove CMake 4 workaround!" if version > "3.2.0"
      inreplace "CMakeLists.txt", "cmake_minimum_required(VERSION 3.0)",
                                  "cmake_minimum_required(VERSION 3.10)"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPHYSFS_BUILD_TEST=TRUE",
                    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<~EOS
      addarchive test.zip 1
      cat test.txt
    EOS
    output = shell_output("#{bin}/test_physfs < test 2>&1")
    expected = if OS.mac?
      "Successful.\nhomebrew"
    else
      "Successful.\n> cat test.txt\nhomebrew"
    end
    assert_match expected, output
  end
end
