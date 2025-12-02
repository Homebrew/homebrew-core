class Ispell < Formula
  desc "International Ispell"
  homepage "https://www.cs.hmc.edu/~geoff/ispell.html"
  url "https://www.cs.hmc.edu/~geoff/tars/ispell-3.4.06.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/ispell/ispell_3.4.06.orig.tar.gz"
  sha256 "17c91633d4c8075acc503163a16463fc54ab1c7453280ad39cd3db75c783eba6"
  license :cannot_represent # modified BSD license

  livecheck do
    url :homepage
    regex(/href=.*?ispell[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "46a439e8c57a40cc6102c1884e11c9e261286787efcd5b72fd3df42487216d17"
    sha256 arm64_sequoia:  "fc52b0f23b84dbe44eba8d0ef80ae93927f90591678155d6579af7e04819abb0"
    sha256 arm64_sonoma:   "f59130f4372ea62fbc0e9eb4278f334c2c0560bda769da34124eaa09be982308"
    sha256 arm64_ventura:  "55b954a652b789b190d4ec1e6ff44dadfe98dc3136c7b1a7899a4ca98ba69dac"
    sha256 arm64_monterey: "50ddb869e8a2cbac73c222c44c3d0fc05e53e688fea457f9f36f6bccc4eebabf"
    sha256 sonoma:         "b694e02bc0e7ed4f22e3cb6acbc65e102ce247f7e51b56c5993f0d9e257a923f"
    sha256 ventura:        "09c4567d275b8bc4aaf705c61b55415efc4ca531d1aac0affc77accf25f37cbb"
    sha256 monterey:       "2823acb91a77394cb0cc476ad86713e5a40de442e3f6a3e8b50837db31ad0468"
    sha256 arm64_linux:    "9b9d077e2087198423033e13a10e3b918d078dd7e5bd39a798ebeb92899d5249"
    sha256 x86_64_linux:   "869cb27e3534e6aa9503dd0598a7115207ddf665f8183fd14f99dd931f61fe6c"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    # No configure script, so do this all manually
    cp "local.h.macos", "local.h"
    chmod 0644, "local.h"
    inreplace "local.h" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "/man/man", "/share/man/man"
      s.gsub! "/lib", "/lib/ispell"
    end

    chmod 0644, "correct.c"
    inreplace "correct.c", "getline", "getline_ispell"

    system "make", "config.sh"
    chmod 0644, "config.sh"
    inreplace "config.sh", "/usr/share/dict", "#{share}/dict"

    (lib/"ispell").mkpath
    system "make", "install"
  end

  test do
    assert_equal "BOTHER BOTHE/R BOTH/R",
                 pipe_output("#{bin}/ispell -c", "BOTHER", 0).chomp
  end
end
