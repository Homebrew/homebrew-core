class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.8/fribidi-1.0.8.tar.bz2"
  sha256 "94c7b68d86ad2a9613b4dcffe7bbeb03523d63b5b37918bdf2e4ef34195c1e6c"

  bottle do
    cellar :any
    sha256 "69403ab9b10c4e20ebbf4ace214fa89e2c055b9f7731871553e62a7065e31aaf" => :catalina
    sha256 "b0084d49f6e420509f1f7d0ce0fb84be563302f1b907c12f1f8f53bda2b5ab15" => :mojave
    sha256 "3b33566bbc8df22d57ee931b5de5fd59ab2d76058c26e20000deffaace90ffe2" => :high_sierra
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
