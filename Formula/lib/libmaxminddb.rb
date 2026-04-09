class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.13.3/libmaxminddb-1.13.3.tar.gz"
  sha256 "a66502ea76eadbe17f2cd6fd708946777253972d2ae8157dee1b23a2fb528171"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5936b3b75b64cab056955f2bb8c0b756fa60c53804dcd7dbde8abad2abceed84"
    sha256 cellar: :any,                 arm64_sequoia: "490b3efc56371925d11362dd017550824c13573c4b76edb4fa2848c549d46692"
    sha256 cellar: :any,                 arm64_sonoma:  "dd18810ef2ff421397f0841540e9a8ed078bee4d99943e45fbed763e39ba6a70"
    sha256 cellar: :any,                 sonoma:        "7aa6d1a05efe76995a324af5ea06acdc8dc5428f2dbd9fad2d7c098af91c1f5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9546178cbb2f9b8d6b585c18d109f5fcc8b7bce72431e97654c5da23cbc94b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fbff53ca34d511f0c71bb801ef011da1808855abb303957cf783069bd4e35f7"
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
