class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.22.tar.xz"
  sha256 "eac15b82b5ba5ed0648af580221eb74657394f7fe768e966d9e9ebb27435429f"
  license "BSD-3-Clause"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "16973541660ff3601f6ea87f1553bac63e63cef2cce49a83d078293b0c66d56f"
    sha256 cellar: :any,                 arm64_sonoma:   "3920adaed9ddbc3361b4f47aa15bd3f3fca316238b22b52ba22df4402f1482f9"
    sha256 cellar: :any,                 arm64_ventura:  "23c5829dd8a2703925dbb711266cc62892d436bdc05fa2cbbf1dc280fd3e73f5"
    sha256 cellar: :any,                 arm64_monterey: "076cb8bf82d2ff6a0ed354a09a649526d02fe7c43bab9febb3ec1ad20b6a5281"
    sha256 cellar: :any,                 sonoma:         "f659f9cc27081184571adaec90ab1ec3e58c6e2f3007ef2df205f4a0d58603c5"
    sha256 cellar: :any,                 ventura:        "a6888a6f14f59dcfbcd73cf9c9ee915d68480fa03bc8c296896ea03e3214bb53"
    sha256 cellar: :any,                 monterey:       "d634d83c7d8e29e6d68ee52000160d86bbd83dec4b59084844dd838e77ae9139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e56f369d58e7d23eafe3d6d8dcfa0f5eca8daa9c732582f4938ff99abad183"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
