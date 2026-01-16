class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.19.0/elinks-0.19.0.tar.xz"
  sha256 "a993a4870cadce60abbc724cf6a5c2a80f6be9020243b9e5ce075c16c6665c04"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71ffd50b78f14dff3602fafb9e249b3a1a712586698efdf4c6a32d39969b2341"
    sha256 cellar: :any, arm64_sequoia: "1cad2a0ebe892022f566f2350c3fb74f30c0072977b5ea9c52bb246d00d20182"
    sha256 cellar: :any, arm64_sonoma:  "de00151cc952660577f1897ffa5b684cd2751829c8b5d0eb671dce6b1221ee78"
    sha256 cellar: :any, sonoma:        "bd0d4493bef7fd0ad399cc6d5b366c6b22bd4c04a0f444cfa7318deec24cc040"
    sha256               arm64_linux:   "d7cad94afe5316f5449eb7fc8a7a70ce40c7a267357e78a507619c8293bd9529"
    sha256               x86_64_linux:  "267e3566b8e3bc552eb4b808a82066ccc6cd8c0b963a1b532ac49bd6e3ece906"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libcss"
  depends_on "libdom"
  depends_on "libidn2"
  depends_on "libwapcaplet"
  depends_on "openssl@3"
  depends_on "tre"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "python"
  uses_from_macos "zlib"

  def install
    args = %w[
      -D256-colors=true
      -D88-colors=true
      -Dbittorrent=true
      -Dbrotli=true
      -Dcgi=true
      -Dexmode=true
      -Dfinger=true
      -Dgemini=true
      -Dgnutls=false
      -Dgopher=true
      -Dgpm=false
      -Dhtml-highlight=true
      -Dnls=false
      -Dnntp=true
      -Dopenssl=true
      -Dperl=false
      -Dspidermonkey=false
      -Dtre=true
      -Dtrue-color=true
      -Dx=false
      -Dxterm=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    HTML
    assert_match "Abracadabra", shell_output("#{bin}/elinks -dump test.html").chomp
  end
end
