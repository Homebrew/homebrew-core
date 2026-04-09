class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.19.1/elinks-0.19.1.tar.xz"
  sha256 "31960cd471246692b84008bffec89182f25818472f86ee1a41a09bf0dad09eeb"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1bb748fa85a2021054ecfbc078da2ed3201320744a218d340732298fd90536d8"
    sha256 cellar: :any, arm64_sequoia: "2f33fbb408dfd33c93ef83260d52a7cd6a48fbc3cad7e9c49940adcc5e92f734"
    sha256 cellar: :any, arm64_sonoma:  "4149fe333d1d8522477d583dfce6eb4ba8e7369d6fff378cc7f59b69b8faf343"
    sha256 cellar: :any, sonoma:        "25835e28f28a67984128bdeafe0ad342be1a5a4b649a4d4176ba227ee7cce737"
    sha256               arm64_linux:   "5b6fa5b978fe374293f29e46dd8870c7533d67ba94170285e8dc9f261340f159"
    sha256               x86_64_linux:  "2bbd226d828e84ea9ea36a907498ff54712896f49f3a407a8709c904e567c02a"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
