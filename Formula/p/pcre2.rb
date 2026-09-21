class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.48/pcre2-10.48.tar.bz2"
  sha256 "b6c68fdf6f3ac31388b50aa89ff0fc49c00c987c16e7b5146491d12003f2c8ed"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0b27d55ce599c9f208dd0ecef2d4e081c32044cda68b53e81d3aad550a04a991"
    sha256 cellar: :any, arm64_tahoe:       "46681bd5769d4c0ab2aec568ff400ea00a69e9e5e05dc32b360bcf113b0af278"
    sha256 cellar: :any, arm64_sequoia:     "a24eb46d4ae083117c3ab683d631b6f510979bda74ee1e82a307e8ebe259904e"
    sha256 cellar: :any, arm64_sonoma:      "eb8e1a4b93f9bbd228ac41336fa83085de6a1ab47593c8326d2e3544736fac88"
    sha256 cellar: :any, arm64_linux:       "e3802b431ae9387433cf2abad3600b7fd9e4fa7688d9069f6e806b14fb03437a"
    sha256 cellar: :any, x86_64_linux:      "73de8eb8fc25969a27d3b204c07034760da8de01524794706a6d874a62bca575"
  end

  head do
    url "https://github.com/PCRE2Project/pcre2.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    args << "--enable-pcre2test-libedit" if OS.mac?

    system "./autogen.sh" if build.head?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
