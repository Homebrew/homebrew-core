class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.13.1/libmaxminddb-1.13.1.tar.gz"
  sha256 "49a2347f015683d83c5a281c1b2d38ca766a1f42d5183417973bf4ca9b8c4ca7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb55987a852b83ee04fc9757a9b50673d873722194d3f99154ded5743cc318d7"
    sha256 cellar: :any,                 arm64_sequoia: "1b13f50a8072072af83d8fe5851dab623f05967b35868ac4bf95435c4b7a423e"
    sha256 cellar: :any,                 arm64_sonoma:  "483e40580b6cef8ced628c5c9b072004ae2c7d9f2615473dc62e2b5210d3ec51"
    sha256 cellar: :any,                 arm64_ventura: "4b4c4de2cf912a0e0e764bd02052efc651160b547f40ee573a5bc0d6d95fb070"
    sha256 cellar: :any,                 sonoma:        "287f6e846279aba4823828756b8c9a02537fa3ca26f2edd0ed6dfb8b9a43611d"
    sha256 cellar: :any,                 ventura:       "5621888987d823a633346238e0044ca73d1a0a07a9a5eae43aa06dffd261475d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "288980ac6d2f257040998e48a827e2234c279304e510dba80202259c78727af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f050b168b6f1ed601acad6218d45bab50d416eb062317614d662a5a63372f5af"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix compilation failure on macOS
  # https://github.com/maxmind/libmaxminddb/pull/419
  patch do
    url "https://github.com/maxmind/libmaxminddb/commit/0138e84e81f840e885d3a430f70189c1e82759a5.patch?full_index=1"
    sha256 "8836251acb7610993494d378ec79f1a945fa7ddd542739e14a27cd274888233a"
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
