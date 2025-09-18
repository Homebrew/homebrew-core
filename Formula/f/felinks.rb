class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.18.0/elinks-0.18.0.tar.xz"
  sha256 "e56ef15996a1ca130789293ee6d49cbecf175c06266acfa676fa6edb271a1173"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82aa634f9e6032e50868a8283b1e271925240a48e63b172b6f778776c289c4eb"
    sha256 cellar: :any, arm64_sequoia: "529eb6faff1708b4e77d43909e658745d00b7eeacb37fb3db72e8b2bc7d558f9"
    sha256 cellar: :any, arm64_sonoma:  "218fe1fdc56e6c73245834c41763b66d4277a85737b30a093eb4b15c38dd8c50"
    sha256 cellar: :any, arm64_ventura: "fdee3c49900a48edafb82435144c94a2ddcaeecf30646b606a604e7ff3f4ca73"
    sha256 cellar: :any, sonoma:        "c7d99c15f1ac89441b4de54cb413e22e6c096fc88828e5461822c5c6f8dcb856"
    sha256 cellar: :any, ventura:       "0f268c3811c863f325f50c0d36bfffcb8d54d9d258871afa4501c2a6a71c2080"
    sha256               arm64_linux:   "eff4235e7a240d220af0ab641c16c06e29a35ba2f655733d6fd6560cffaf0009"
    sha256               x86_64_linux:  "f0ca366d10b01c506710abc06dec5f57ade08f76c4f233d2ce353e28c75bec2d"
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
