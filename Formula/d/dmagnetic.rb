class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.37.tar.bz2"
  sha256 "ad812bb515bc972e23930d643d5abeaed971d550768b1b3f371bd0f72c3c2e89"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "1d303cc3cb631d54618e5c0d4f0f84590d3396dd85ae4826f065f6a5ebd7a7e6"
    sha256 arm64_sequoia:  "9f840a9ccf56d119e074527daa5b430d0670bd1425a44efa2882459e279ba40c"
    sha256 arm64_sonoma:   "4a2cb2a7d9d5334b230ec1f3e475239b3b780aa686d3ccacc8a1d5a014332ca0"
    sha256 arm64_ventura:  "53df75a05a62e3cf42f523b646e8e98bc24f918c86461417f7c58460ad7bb5fe"
    sha256 arm64_monterey: "46ece6d5aeee62439640ef8ac80332d959ccf26e4e152bb217b6e4ee4578a71a"
    sha256 arm64_big_sur:  "dddfa700cb7a131c7569b81a86883aaa829ef6786130f2253cdafe4b6ae0d14d"
    sha256 sonoma:         "8875753d82c275224ab8a96db378e71d23dc4d94f4cdd7b8938bd7e997585f95"
    sha256 ventura:        "53b7f3052773759db150a337a05f47d400a1815d4091a03fe4c356099fe9ed8b"
    sha256 monterey:       "3be7370bdd40ef1996d44c90ebea5e0a79e00f698a15567e138b52222a5d14d9"
    sha256 big_sur:        "03cf51b58df1758d4091ef85325843ccf4dd8ea122f5eae0f7dbbdda20652ca6"
    sha256 arm64_linux:    "d2f8462efd3fae04c958d7af9918a011f98343627968b1ffdc9ad24619a24c59"
    sha256 x86_64_linux:   "f2ccdaa11d29351b10335eb79f20f4ffeb23029d542a867fe0e6bc2274618a1b"
  end

  def install
    # Look for configuration and other data within the Homebrew prefix rather than the default paths
    inreplace "Makefile", "DESTDIR?=/usr/local", "DESTDIR?=$(PREFIX)"
    inreplace "src/frontends/default/pathnames.h" do |s|
      s.gsub! "/etc/", "#{etc}/"
      s.gsub! "/usr/local/", "#{HOMEBREW_PREFIX}/"
    end

    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    args = %W[
      -vmode none
      -vcols 300
      -vrows 300
      -vecho -sres 1024x768
      -mag #{share}/games/dMagnetic/minitest.mag
      -gfx #{share}/games/dMagnetic/minitest.gfx
    ]
    command_output = pipe_output("#{bin}/dMagnetic #{args.join(" ")}", "Hello\n")
    assert_match(/^Virtual machine is running\..*\n> HELLO$/, command_output)
  end
end
