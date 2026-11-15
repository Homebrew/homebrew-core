class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/archive/refs/tags/v1.6.tar.gz"
  sha256 "52807d887d60646776110b63543d3845ebe9ed52d3eea44bed7c4bdd95b6575e"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "744a5e14a51612494cf8e3d12309793158b230554e63c7d2ac96363232fb7acc"
    sha256 cellar: :any, arm64_tahoe:       "7faeeeafe0d8fe698edc5d398ec2352a91724df5bc46f8d1161d918202ed4ef9"
    sha256 cellar: :any, arm64_sequoia:     "e85c04e13db9d2f29031a5f1113cd39f0ba94bbb9ec9a42d74be052ed590b0bb"
    sha256 cellar: :any, arm64_linux:       "ea51ebe3e6c6a2e17eb028a5c24346e37525f3d04c048b0d40e403064671becd"
    sha256 cellar: :any, x86_64_linux:      "0c6ace886ee388b3b94dc0d56ddf7681c1562d305f4c17a7af7c8d0ac0b77519"
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

  # Support faac 2.2 `faac_params_init` signature
  patch :p2 do
    url "https://github.com/rafael2k/darkice/commit/e4f1e83b6582cd4602b6387f02882d72490b7854.patch?full_index=1"
    sha256 "76b2b310d5052bff7902391e6676bf3e46f64dff3828773ca3f804bb6a99097d"
    directory "darkice/trunk"
    type :unofficial
    resolves "https://github.com/rafael2k/darkice/pull/216"
  end

  deny_network_access!

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
