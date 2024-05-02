class Darkice < Formula
  desc "Live audio streamer"
  homepage "http://www.darkice.org/"
  url "https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz"
  sha256 "e6a8ec2b447cf5b4ffaf9b62700502b6bdacebf00b476f4e9bf9f9fe1e3dd817"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "af910d1b4f053b52d0be917a698954a5903bebeaaaf7015b62fdce29ea4b4749"
    sha256 cellar: :any,                 arm64_ventura:  "d0db564fd3fad3478ae882b45007229aa010fa374fde2543fbcd453357a964a9"
    sha256 cellar: :any,                 arm64_monterey: "0c114d7e19e2a1fea948adbf40be5566dea4d9a21888448aa48cad337e1aefa7"
    sha256 cellar: :any,                 arm64_big_sur:  "74ea8b8e64aa084b45b2c0f54cf77617960a4de2e3ab14601375e4242fc74f0c"
    sha256 cellar: :any,                 sonoma:         "3cceeffac938178db89da3fdccc54454d405b0ea875d360d41f6ced8be5a7e36"
    sha256 cellar: :any,                 ventura:        "a63714cf7139435583c9d7ee8f1f2f3627d386063beb6cd0767b47d28f721b02"
    sha256 cellar: :any,                 monterey:       "a07e77aa24879c67883e75d3fb73b7003d98fc59d6b9f5da24d64789727e1ea1"
    sha256 cellar: :any,                 big_sur:        "7bccd99a386891b98e1085300243152a8bd82fdaa0fe20d9b83448460711d2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc68231f2235a681304aa5821ab187cb220977aa0ae4e7ef48eccd9de3a3c43"
  end

  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "jack"
  depends_on "lame"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "two-lame"

  def install
    ENV.cxx11
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-lame-prefix=#{Formula["lame"].opt_prefix}",
                          "--with-faac-prefix=#{Formula["faac"].opt_prefix}",
                          "--with-twolame",
                          "--with-jack",
                          "--with-vorbis",
                          "--with-samplerate",
                          "--without-opus"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darkice -h", 1)
  end
end
