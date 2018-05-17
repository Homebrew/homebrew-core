class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.3/fribidi-1.0.3.tar.bz2"
  sha256 "8d214b17b6eedcb416e53142c196c2896b9a685fca2a5bddc098a73d2b02ce12"

  bottle do
    cellar :any
    sha256 "139434ded4f6455fef216b33fb5cdc713cc1692f457ae56058ff512a5d64abc0" => :high_sierra
    sha256 "0588e9731bf34db77b4bfc4bea72d8d84196bebc9badb2edce6d8c37f02159de" => :sierra
    sha256 "ad4d83225cc078de5a60c3d5d76224761a712c6c521f548e9913ceea0b62c051" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
