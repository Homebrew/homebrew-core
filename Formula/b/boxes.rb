class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "9318ef65f555ee3d893176349a4219f1f1260ce24d4100aeb667a546f61fc183"
  license "GPL-3.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "18b068eb59f4fd0941f50908bd2778481262ae97e92e5ebf90ae551b6606402f"
    sha256 arm64_tahoe:       "88975ffc5b34525ca171ba818b658294644753139db96d716e548edb37ed390c"
    sha256 arm64_sequoia:     "27a303dbf09830d2e13e1444dd7743b2995da3c5e76313b2277a24a03baa5181"
    sha256 arm64_sonoma:      "d756f584338d814cab0decf5970c1ad60cc74b00fd5ba929103b2204e3795a9b"
    sha256 arm64_linux:       "4de86a5db7e1436cc42bbc01dc04a474ff35fcad73d9eec8888e7aaa1360ccb8"
    sha256 x86_64_linux:      "17a2a560ecf77502e226c592de2adca834894048f9c4b0d80213f2354259187d"
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
                   "YACC=#{formula_opt_bin("bison")/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output(bin/"boxes", "test brew", 0)
  end
end
