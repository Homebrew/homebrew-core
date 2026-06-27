class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.25.tar.xz"
  sha256 "5170a9ae998241a936fce150e6859d84db92330b80ad2d0f2adce6689eeb5401"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libmpdclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "85065fcb5b2aee5bc9d7aacead08d889a2f7d59ea096de716ebc4d52f534d032"
    sha256 cellar: :any, arm64_sequoia: "02c4eb9f272d2e641c8ab4451d120e038ceb1fbf27f297c8110d0bcbb8da24af"
    sha256 cellar: :any, arm64_sonoma:  "ef0b2b19130c48bfa9fedb150231d5a5b4b16057334b8a990d3a0fd2c7cd2526"
    sha256 cellar: :any, sonoma:        "510eb974af100527b0e4a6cbe396080648b18138c25c1fa61de6225c61647435"
    sha256 cellar: :any, arm64_linux:   "80a6fc7eead5e2c59eff2bae6d0f8f3190c95c3cb3c53a2daeb62c998254aa0b"
    sha256 cellar: :any, x86_64_linux:  "ecccd87dae1450a2b7500e78cab1c37f953d6644564b70607d4e55476f149357"
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
