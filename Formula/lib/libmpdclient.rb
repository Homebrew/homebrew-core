class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.27.tar.xz"
  sha256 "88945b5abc11d8f4cea2bb7028e545024a6e060650bd65527a29bc9400daead8"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6cc02e68cc64ab16097aa692768a74a9aefea3019e2d28c93815d37037d1d452"
    sha256 cellar: :any, arm64_sequoia: "f9d11ae93a379be01a8a8eccd85a05b3fa32deeca0e460d6b7787d1317bc697a"
    sha256 cellar: :any, arm64_sonoma:  "18ef29e088182fd692467747b96d0fdca62915c3225e473685a8b26bc29d2e75"
    sha256 cellar: :any, sonoma:        "2aa2352f1692e61fa919d2f327e55467035581394584f87e0ec92e60ea0d3a96"
    sha256 cellar: :any, arm64_linux:   "733e9259511c3c6cc0b0539dadde5051979504b4a8015049720d7c8d842e383a"
    sha256 cellar: :any, x86_64_linux:  "44ad3dec89db20db9c2910d0fea07d29854a7ab44398bd381afad05ea3914c23"
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
