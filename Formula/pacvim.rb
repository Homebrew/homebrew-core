class Pacvim < Formula
  desc "Learn vim commands via a game"
  homepage "https://github.com/jmoon018/PacVim"
  url "https://github.com/jmoon018/PacVim/archive/v1.1.1.tar.gz"
  sha256 "c869c5450fbafdfe8ba8a8a9bba3718775926f276f0552052dcfa090d21acb28"
  license "LGPL-3.0-or-later"
  head "https://github.com/jmoon018/PacVim.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52a18b2f8a5a6e9ab6f2c31c08432c44c3f00183e18c80154a5c6f8daa069160" => :big_sur
    sha256 "b690b089d153174f596700e750e133228e05949b3c4d01c993d93b862b102dc0" => :arm64_big_sur
    sha256 "85bd0087ecc54716772881e46ce00553ee037eb2ea200d34d5db28709092369f" => :catalina
    sha256 "e2ecd6cc1337adb4c9e760c50a83ae04a8cb86495d3c1ea167bfa5930d7a16a0" => :mojave
    sha256 "b8ef8cdba34802db97fba770e013393973e908e11486b87a4f5189f139e468dc" => :high_sierra
  end

  uses_from_macos "ncurses"

  on_linux do
    # Use ncurses.h instead of cursesw.h which is not installed by brew
    # https://github.com/jmoon018/PacVim/pull/31
    patch do
      url "https://github.com/jmoon018/PacVim/commit/2f95ef4d312d760b8a3aae463e959646b27e774a.patch?full_index=1"
      sha256 "e5b753de87937c0853a1adbab31eb1ec938add4ceb0df26eafef5b4f613bc3e6"
    end
  end

  def install
    ENV.cxx11
    system "make", "install", "PREFIX=#{prefix}"
  end
end
