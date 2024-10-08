class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.2.tar.bz2"
  sha256 "faabf6157c8cb1b24a059af276e162fa9f9a3b9cd3810c43b9128860c9383a1b"
  license "GPL-2.0-or-later"
  revision 18

  livecheck do
    url "https://rybczak.net/ncmpcpp/installation/"
    regex(/href=.*?ncmpcpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87e6097bb1197995aac78dac724f227bdcbcd17b253bcb0d7caa3e6e79e59a5f"
    sha256 cellar: :any,                 arm64_sonoma:  "67d73c172be28c9f644500ca34a6a809429e84ac9865908ea3f3067f8f9b1cb8"
    sha256 cellar: :any,                 arm64_ventura: "eb1c978c8fdaa32c2a91812d31f6187e8c513ff44a4a6c327f64174d985f2d2e"
    sha256 cellar: :any,                 sonoma:        "9017705dc5879ee65956fd43d43bf75bf0afa36df5d01a5dd5194903b5f86a94"
    sha256 cellar: :any,                 ventura:       "20feeb1d157ac235c2bf18c7a50d43a9284bdbc8b1c0d29e6fe8ee924a52aab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d3832e67611b3860d18102d8648982326ebb7e91869d3d237eeeecb5693d7e"
  end

  head do
    url "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c@75"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  def install
    # Work around to build with icu4c 75 in stable release. Fixed in HEAD.
    # Ref: https://github.com/ncmpcpp/ncmpcpp/commit/ba484cff1e4ac3225b6eb87dc94272daca88e613
    inreplace "configure", /\$std_cpp14\b/, "-std=c++17" if build.stable?

    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %w[
      --disable-silent-rules
      --enable-clock
      --enable-outputs
      --enable-unicode
      --enable-visualizer
      --with-curl
      --with-taglib
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
