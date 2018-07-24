class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.5/fribidi-1.0.5.tar.bz2"
  sha256 "6a64f2a687f5c4f203a46fa659f43dd43d1f8b845df8d723107e8a7e6158e4ce"

  bottle do
    cellar :any
    sha256 "a62985d7379028d81fc6c448af8d93e03ccab027b219b2b741fbeb693f015bc0" => :high_sierra
    sha256 "2a6caa7a26af35e9349584f27062c0337e99a4a7e9514abe46bf9b0f0f674d49" => :sierra
    sha256 "dd024aeef4beec89ce9ce1058f2be466412aaa4a3af67d08d17ac31adb00f08d" => :el_capitan
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
