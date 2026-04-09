class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/archive/refs/tags/v1.6.tar.gz"
  sha256 "52807d887d60646776110b63543d3845ebe9ed52d3eea44bed7c4bdd95b6575e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20fadd1b316d8b747e228c02b325d21329a90591a3aab8b02bcfe02d4898a905"
    sha256 cellar: :any,                 arm64_sequoia: "0958adc999ddfef904b1b9df902c624cf22fcfc2dc85d04baa6764dd530ad378"
    sha256 cellar: :any,                 arm64_sonoma:  "736bf8e9a4e8d8fac78557dbd7cd3cacf25998edc324271a75b8ea4fcdca0835"
    sha256 cellar: :any,                 sonoma:        "ebde2620aa8397e50338a25ba5d370ef82fbe08ed2b4c9fd7da46baef13fac45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02aeec8949bff8c5e533dcc7bf3b55793a96f791b3f053ffbf5457da241e0733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26e67b2c6571fc9bafab6e97febb01e97e86f9f77a18397b1e08ccb944c4805c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "faac"
  depends_on "fdk-aac"
  depends_on "jack"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "two-lame"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    # TODO: Remove when source is back to the release tarball
    cd "darkice/trunk" do
      system "autoreconf", "--install", "--force", "--verbose"

      system "./configure", "--sysconfdir=#{etc}",
                            "--with-lame-prefix=#{Formula["lame"].opt_prefix}",
                            "--with-faac-prefix=#{Formula["faac"].opt_prefix}",
                            "--with-fdkaac-prefix=#{Formula["fdk-aac"].opt_prefix}",
                            "--with-twolame",
                            "--with-jack",
                            "--with-vorbis",
                            "--with-samplerate",
                            "--without-opus",
                            *std_configure_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darkice -h", 1)
  end
end
