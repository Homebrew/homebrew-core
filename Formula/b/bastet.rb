class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 11

  bottle do
    sha256 arm64_sequoia: "4f2a75e89523a611c43e835885e8a88ce1969c829d53285815338ee3b6870274"
    sha256 arm64_sonoma:  "36d7d9ed8c1661e91989775501e2fb37f93e7293adaed83b10d816ab85a8d6dd"
    sha256 arm64_ventura: "f35791ce54bddbda1f3812bff67957693fe791ca4c9c023f8afeb868bb74c73e"
    sha256 sonoma:        "36f49100437319373f0c97a0f2e6a04f314e5a6e7fe70e19f4a10a92157399a7"
    sha256 ventura:       "bf1b93563715abc343a11e63a351ad9a3c9f8d5348a4f4742636a116ceb4b72f"
    sha256 arm64_linux:   "a8785e6b7bf3304eb37a4550cd19ba6715a9d8b77babbf5e1308bbe81cc0de72"
    sha256 x86_64_linux:  "a07a23ef63af7763e40f927c8deb51effc415fe71ee3c7baadebc716fab9dd58"
  end

  depends_on "boost"
  uses_from_macos "ncurses"

  # Fix compilation with Boost >= 1.65, remove for next release
  patch do
    url "https://github.com/fph/bastet/commit/0e03f8d4.patch?full_index=1"
    sha256 "9b937d070a4faf150f60f82ace790c7a1119cff0685b52edf579740d2c415d7b"
  end

  def install
    inreplace %w[Config.cpp bastet.6], "/var", var

    ENV.append "CXX", "-std=c++14"

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end

  test do
    pid = fork do
      exec bin/"bastet"
    end
    sleep 3

    assert_path_exists bin/"bastet"
    assert_predicate bin/"bastet", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
