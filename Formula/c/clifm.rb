class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.13.tar.gz"
  sha256 "44eeba9416e2dea6d9b61cddb414471828d3a794fefc6b6e9fe3aa5445454120"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "656832b90a7372696a2b075f87349ea32ef9f9b250c6383d23bdda1163042ff4"
    sha256 arm64_monterey: "4597e13d7408276cc5688196991eda7940e1357574f6043449cdda7307754aab"
    sha256 arm64_big_sur:  "15e48e60e3dd33f2a3f19c139a02127e45848c074bdb9ec43bf75cb7ced136b9"
    sha256 ventura:        "a77344b404aa845cb0dca8f2b43b0a77a1b359ee235dec795fd1142ae39f731d"
    sha256 monterey:       "4c2502bddffa8fc67b1f8dedeabd5e668a34a9841f6953fa7ecef1dd109ae375"
    sha256 big_sur:        "454b8df8e4f12a0ae238c41402cb2d8c2e2f1b7db03889cf334e5d025faf92b9"
    sha256 x86_64_linux:   "9b1d11e9a40a7d1761d06435be0c0a077c7d6871e126ce02328076bcbf4585d2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: nonexist: No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
