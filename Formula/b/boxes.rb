class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "0834e54c0d5293950412729cabf16ada3076a804eacba8f1aacc5381dfe3a96a"
  license "GPL-3.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6ebfa16105de5a5f1a0d46b7742afb09b97c6bcbe59d98c80bdf6e7057350917"
    sha256 arm64_sequoia: "947c884cec8f4ae8248bff97af51e7d2d3bacce6ea7cde86831e0895c67471be"
    sha256 arm64_sonoma:  "503df5e97899ffc0a24982b46f265a82a7c4f138e656273b4eb2ed4752881b05"
    sha256 arm64_ventura: "d83c635c1a99655fcda01132851aaa92d9ed54e7d331c9a3e2f32c072a7aa122"
    sha256 sonoma:        "00df90a0d846b02d58d16302daba7d9949d3c8cf4db7fe9bdd10f8c32b1e5679"
    sha256 ventura:       "a8c14372ddb54552b296380f436b49ba676ff7ef6d275513c36aadd197435aa9"
    sha256 arm64_linux:   "3934bb6ecfb413871a8311f1884191f0524fe2c1aed1992242ba31dae70a3dd2"
    sha256 x86_64_linux:  "dddb84f6366ff935cf5f1324d3b93d3a7f0e8fc6349d71aa4149a7241e9986c7"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config",
                   "CC=#{ENV.cc}",
                   "YACC=#{Formula["bison"].opt_bin/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output(bin/"boxes", "test brew", 0)
  end
end
