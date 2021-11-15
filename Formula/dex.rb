class Dex < Formula
  desc "Dextrous text editor"
  homepage "https://github.com/tihirvon/dex"
  url "https://github.com/tihirvon/dex/archive/v1.0.tar.gz"
  sha256 "4468b53debe8da6391186dccb78288a8a77798cb4c0a00fab9a7cdc711cd2123"
  license "GPL-2.0-only"
  head "https://github.com/tihirvon/dex.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "b0862918ef89cb4018a08662ec18ca36fab573fdf1e44696fd32813b9f40957c"
    sha256 arm64_big_sur:  "f8ffe6f83659dbdf5f60ee7367291371a1b5cb502ce288ba76d7d392ad943c85"
    sha256 monterey:       "1161d38da36fd3affca64b1b45f68a98e2b935cf1a25418f079f30ed1538eaa3"
    sha256 big_sur:        "32ae7c5467361a979d7e96249ab4f95af72b202e260064a4c0ba58455ba44034"
    sha256 catalina:       "d59f96c9f1e021bc400a832d680039313256073d88527ef18b961e783c71879b"
    sha256 mojave:         "689a8e1a94a3c2922defac96859aca9b4675118858d9abc8338c0687cf714f43"
    sha256 high_sierra:    "1d36402b9470f2e714bf9b9b94e9575d06130485559826a08181ff9087e77176"
    sha256 sierra:         "1e413a64cd9e2c594ec47c7e5e9ff36ab199126f6708265f5ad87363e66f033e"
    sha256 el_capitan:     "70c249809920acc2d10405c0487427d154ee55cf201507d910d8178693c7fd61"
    sha256 yosemite:       "a4cffc5c0b61be9452988d4435ccff1d1c72d2b9cdec595e55ea5f37ca2541a6"
  end

  uses_from_macos "ncurses"

  def install
    args = ["prefix=#{prefix}",
            "CC=#{ENV.cc}",
            "HOST_CC=#{ENV.cc}"]

    args << "VERSION=#{version}" if build.head?

    system "make", "install", *args
  end

  test do
    system bin/"dex", "-V"
  end
end
