class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  # note, homepage did not get updated to the latest release tag in github
  url "https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ddc89da86595d272282ae8726cc7913867b9517eec6e765e66e6da860b58e2f9"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/ncmpcpp/ncmpcpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d3952dd1fe33dfdaed148c9c2760d248a1e38ad2e0489cd016efa1e40e1fedd"
    sha256 cellar: :any,                 arm64_sonoma:  "9abdee3a1db5887e8a2abfffa20d239b63bdccbc1ba21ea8c9308f970d249a26"
    sha256 cellar: :any,                 arm64_ventura: "d838e95e3232cb04000e9b6008a7c37ff4b6cc4b4eb256cc8f81d6e1b68b123e"
    sha256 cellar: :any,                 sonoma:        "d8456d9b61e01f683c22e1ff17ee2f1faa876ef5c4481292bc13f9b7b7da4cd2"
    sha256 cellar: :any,                 ventura:       "c89a3bac72e436f4418dcaba5aa1c1a98f927c0492de322c23899c81b05ba846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920744f73ce58f8823b6dbca950d1092df19ee795fb34f3842a32ae4581bd3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78173a6f36df653878347947f0a93b9a3da9969ba385be92186e62c300cbce3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "icu4c@77"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.prepend "LDFLAGS", "-L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["readline"].opt_include}"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %w[
      --disable-silent-rules
      --enable-clock
      --enable-outputs
      --enable-visualizer
      --with-taglib
    ]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
