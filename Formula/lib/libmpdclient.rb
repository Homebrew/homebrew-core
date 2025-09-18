class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.23.tar.xz"
  sha256 "4a1b6c7f783d8cac3d3b8e4cbe9ad021c45491e383de3b893ea4eedefbc71607"
  license "BSD-3-Clause"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb83530442bed149962b84dbd9deb7d901c4efbbf54f19ab337e0f63ace4fd76"
    sha256 cellar: :any,                 arm64_sequoia: "a6bef70ce4043cd9f2a40eaff30f25530c73f71d769c73520525a2ef095ddcba"
    sha256 cellar: :any,                 arm64_sonoma:  "13230392618659e0d0d68fcc5c64e6081f9c070a8296665504b2dba5aa6f4fa5"
    sha256 cellar: :any,                 arm64_ventura: "f4b4d3a292270d0be8264da107fb15ec1a4b4682cdc7bb7fb204bd353ec73d46"
    sha256 cellar: :any,                 sonoma:        "ae3542c31e96deb857b7d474afb329de63a6455fd7f8bc67287534f35dfbc9b7"
    sha256 cellar: :any,                 ventura:       "03ea3a304da416bfb27443d80812bf200675e60e52e81957a583cf4edf906ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "046a756590f8161c1d171822637eff72c372d875562de487ffc8a67a4b1e7893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbd2b3430628a32ba6a2caf6bcd0237816f58505e88581df0719029df25ce0f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
