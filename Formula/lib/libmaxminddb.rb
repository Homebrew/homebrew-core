class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.11.0/libmaxminddb-1.11.0.tar.gz"
  sha256 "b2eea79a96fed77ad4d6c39ec34fed83d45fcb75a31c58956813d58dcf30b19f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "43bb8e8a6415a6a8c876e862b172600de6aebf567d2b93679ea4c9635717a241"
    sha256 cellar: :any,                 arm64_sonoma:   "a7c74a9f9e34cc8b67250f02c5d022f214cb87e7dc0546913f5673140058c98a"
    sha256 cellar: :any,                 arm64_ventura:  "2bd3e2fc92434f37e9aafb939980db58958ff77e279fb61778ef3998a97b721a"
    sha256 cellar: :any,                 arm64_monterey: "04eccd27e4c727935582e41dc01b773c98d39cedd5210ff9be8d85938e10f7ef"
    sha256 cellar: :any,                 sonoma:         "584958143478cff5e55608958b26e823dfa193b2c0c896539a7ea35fdeb7e379"
    sha256 cellar: :any,                 ventura:        "a879b5eded505525e03c0f9bb267828969219e1bc30f989d3017bbaa85593830"
    sha256 cellar: :any,                 monterey:       "ac9b42405f8bd7453b7ed914fdf183db3d98bcf8f7ff333a380cbb3c1dbd177b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d267f70b18104171e39c55d8d08a6ebdd3e0e74205eff1b80611507e14f9880a"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system bin/"mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
