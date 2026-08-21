class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/archive/refs/tags/v1.6.tar.gz"
  sha256 "52807d887d60646776110b63543d3845ebe9ed52d3eea44bed7c4bdd95b6575e"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f52868071d5baea5c71e24a65b9b57990709bbc692e97890a376c0bd29b953b"
    sha256 cellar: :any, arm64_sequoia: "b1a31b332fae851a4779fb56ef6d064fe5e0403a5833210f026d64cfd92c64f0"
    sha256 cellar: :any, arm64_sonoma:  "feb75068c9edb1b2663243bfbbce56dc1247ff0cd3191c85bec1d19b466aa9a9"
    sha256 cellar: :any, sonoma:        "9fe4e5b305dbb8c3c1cb3b61886a82141a9a3013628d8599866f007c4da75a4e"
    sha256 cellar: :any, arm64_linux:   "b0313ba1686502f9d5ec82917fa6e1d1ea306ff2e4f1f0987054a7355c643ede"
    sha256 cellar: :any, x86_64_linux:  "9b0ea67fd05850d09b45a8844d9af57855961eca30b226f72c111d4b066e218f"
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

  # Support faac 2.0 API
  patch :p2 do
    url "https://github.com/rafael2k/darkice/commit/af8c0ad5904bf7bc97ec2d4dfb8f883397009c9d.patch?full_index=1"
    sha256 "c599afb642d374332d63220c80914d3e369400cda3b60068183460d1120fec35"
    directory "darkice/trunk"
    type :unofficial
    resolves "https://github.com/rafael2k/darkice/pull/216"
  end

  def install
    # TODO: Remove when source is back to the release tarball
    cd "darkice/trunk" do
      system "autoreconf", "--install", "--force", "--verbose"

      system "./configure", "--sysconfdir=#{etc}",
                            "--with-lame-prefix=#{formula_opt_prefix("lame")}",
                            "--with-faac-prefix=#{formula_opt_prefix("faac")}",
                            "--with-fdkaac-prefix=#{formula_opt_prefix("fdk-aac")}",
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
