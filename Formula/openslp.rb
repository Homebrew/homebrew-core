class Openslp < Formula
  desc "Implementation of Service Location Protocol"
  homepage "http://www.openslp.org"
  url "https://downloads.sourceforge.net/project/openslp/2.0.0/2.0.0%20Release/openslp-2.0.0.tar.gz"
  sha256 "924337a2a8e5be043ebaea2a78365c7427ac6e9cee24610a0780808b2ba7579b"

  bottle do
    sha256 ventura:      "06a8525267384bb4eea04432b252c8e3063529b99d3d4a7203161115680c9d5c"
    sha256 monterey:     "4fe473351f951da2840deac362acc9d16d5159a30e2e5a84077d1de3ee4dcede"
    sha256 big_sur:      "3cc88f489dfe6e4e9566608ace194fb8e09a8cb28f80947d7454f03494d76341"
    sha256 catalina:     "fee6eb82ad60bf1446278498ff8860584dcd2192a7505f3c57eec2bab55f337f"
    sha256 mojave:       "948182086a86baa001d9b8864715c91d5d9b9ec76ba7c072667dc0d58e983d12"
    sha256 high_sierra:  "3a933a2c697a2b7a00d9b1f9cc3a58664c43c18f7b4ff3d99afa7bc11d721da5"
    sha256 sierra:       "fdd847dba24e5a96c30ccef98f0d035f39abc88617d779df627c132be5b648ae"
    sha256 el_capitan:   "1c19d8355ddda63b9259101a0b7b56ea0fd9fb8f343e2df19f7248542fbf38e5"
    sha256 x86_64_linux: "31a9bf8bd539a71378e4f5f6a438cdef166659e3641a9899213dd166dcaeee6c"
  end

  depends_on arch: :x86_64

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
