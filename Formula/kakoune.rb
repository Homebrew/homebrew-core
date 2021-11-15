class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2021.11.08/kakoune-2021.11.08.tar.bz2"
  sha256 "aa30889d9da11331a243a8f40fe4f6a8619321b19217debac8f565e06eddb5f4"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ba0d6fed5371d8f5012cb0731be90a011cf05dabcffaa51b467117dcf62275"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc941221942a73d79767e254798319842b1849988706e0c41deaaa65c0f3407"
    sha256 cellar: :any_skip_relocation, monterey:       "6361db56b495a4be2855981c95bcfa0ed81ec0e63aace99b6fa06e9340d4ca28"
    sha256 cellar: :any_skip_relocation, big_sur:        "95949d504b4b3d6c87bd4e3cf0e391b3a346ee0166187cf8b43945dd3e6cb826"
    sha256 cellar: :any_skip_relocation, catalina:       "0bf1d69af4e88dd3e7c441c77bbc9ea5f211205883f9a02914b4590035f616e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa06946316f28a0375d5d883b45c899775f9aacff98e13bc8bca7d4721d336e"
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "binutils" => :build
    depends_on "linux-headers@4.4" => :build
    depends_on "pkg-config" => :build
    depends_on "gcc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
