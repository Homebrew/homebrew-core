class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.49/pcre2-10.49.tar.bz2"
  sha256 "53c156e1ba416a20da8e65395daa132da0d80e76910424caca3fcdae7831d384"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5cac44323243138490ca74a2499fd347fa836df6b5fffa789944be12110e91ff"
    sha256 cellar: :any, arm64_tahoe:       "475d36ffae1f472554eac1fd96ca3ead3840c3d8fd2d34b257d2d7c4c1e5a17f"
    sha256 cellar: :any, arm64_sequoia:     "0ec47d18c50f5770db2b3f07b5b85644284cc6ee8e07e23b11d2727e95932b77"
    sha256 cellar: :any, arm64_linux:       "5bab1f9eb587d9f538e0a18589768c71b741dcebd9fd3863d7b5dd35f10ccd1a"
    sha256 cellar: :any, x86_64_linux:      "372ff34217dfe1185894c7ee06dc5c865eea331192c13ed5e62df0babe1b0520"
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
