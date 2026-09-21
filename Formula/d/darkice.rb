class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/archive/refs/tags/v1.6.tar.gz"
  sha256 "52807d887d60646776110b63543d3845ebe9ed52d3eea44bed7c4bdd95b6575e"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "86deaca9d4b02aee9f0f6058ce0956462f12636e821968131b0493cf65df7461"
    sha256 cellar: :any, arm64_tahoe:       "2297df93e2be390ffab2b1daf0a28641b4361d6c5b7e5915f36f513c382b92d4"
    sha256 cellar: :any, arm64_sequoia:     "e5ab28d91352dd0b0edf605275dc37cc5802a86184057d0b7f81f7bcccaec18e"
    sha256 cellar: :any, arm64_sonoma:      "fee50359c0d49db7e2a3fa588d7268d9a73420fc31c6391d5d0fb288e355c990"
    sha256 cellar: :any, arm64_linux:       "3cdc74436042e42443128873c5bf00cfd6d1c274ffe9b9c598e0e742979d7b4a"
    sha256 cellar: :any, x86_64_linux:      "d635e61ce10983ab361e14cd35f1452e4263d3ca65879b226251dd17c5089180"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "faac"
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
                            "--without-fdkaac",
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
