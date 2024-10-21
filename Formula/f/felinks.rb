class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.17.1.1/elinks-0.17.1.1.tar.xz"
  sha256 "dc6f292b7173814d480655e7037dd68b7251303545ca554344d7953a57c4ba63"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ed51c6ce065bf534ad9afc73c0c0d08bc14997909e08145ce1396cbf1ee67232"
    sha256 cellar: :any, arm64_sonoma:  "cde1dda6cb15899341af71934add2202f30a06301cb201bf4f78d7b853d1b13e"
    sha256 cellar: :any, arm64_ventura: "072b62db5ecb6c4590a76cda6baf5fdb55f8a04dddc6c7003f88f8e1925963b9"
    sha256 cellar: :any, sonoma:        "93b19701a3864f59dd29c742ca6c597eb3e6fccac1e9372c5e12bc6e2d21fa81"
    sha256 cellar: :any, ventura:       "31e3c6758ff7b0db2f8b175344f7f3b995bcd8e3fa73a2320ad9d17c8730b729"
    sha256               x86_64_linux:  "305289c38214fa59b864cbd79833beb74ca771fa4f14ec2b0e333b6997334b8a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    EOS
    assert_match "Abracadabra", shell_output("#{bin}/elinks -dump test.html").chomp
  end
end
