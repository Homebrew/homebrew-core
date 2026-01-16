class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/refs/tags/1.19.0.tar.gz"
  sha256 "5c902d4604d18d737c6a5d97d2d4a560717d72c8e9e853b384543c008dc46f4d"
  license "BSD-2-Clause"
  head "https://github.com/fcambus/ansiweather.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "1d6a9dc83687c62774d4adb2da6302dac16f29a985a0eca62cb2a7fcc564a594"
  end

  uses_from_macos "bc"
  uses_from_macos "jq", since: :sequoia

  def install
    bin.install "ansiweather"
    man1.install "ansiweather.1"
  end

  test do
    assert_match "Wind", shell_output(bin/"ansiweather")
  end
end
