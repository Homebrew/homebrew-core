class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.26.tar.xz"
  sha256 "35785c6d6318ade47e2c27b00fc6938f5e09d04714080fea3f5e5c522ba3e036"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b347a6518bf461a466141241b56e105ac43abcf89227f0971da29aa528e4c780"
    sha256 cellar: :any, arm64_sequoia: "2c41582da3647bc3ee8200f9b693deacc09b9073ebc5b2d46ea467d550218d92"
    sha256 cellar: :any, arm64_sonoma:  "e165cd152168b2160bbc5a15df1a10894e75f4ba63189a9f2d8cc32c415943d0"
    sha256 cellar: :any, sonoma:        "1be2167d749f971db2e7d70f0639979535cd121d6a3ade7efe1e36e37464ae31"
    sha256 cellar: :any, arm64_linux:   "b0bd2be4ed178a1a5e0f2c7561c2f47605566bc8237548ccb06f04d367931c8e"
    sha256 cellar: :any, x86_64_linux:  "b7527dafc8ecd89d240a01f144766a810e637d89500fa7cd8a8714880014eb56"
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
