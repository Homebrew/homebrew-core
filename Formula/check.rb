class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz"
  sha256 "a8de4e0bacfb4d76dd1c618ded263523b53b85d92a146d8835eb1a52932fa20a"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "83176da74de92f8ae589d98726f97466f7ccfa91e2b0b58603c4f909d8ce50a4" => :catalina
    sha256 "a54f974e1f874c0912d97d91b61b4ec411d6c9f74417a5c541a7fa1b4bdf7705" => :mojave
    sha256 "9613aefb32a1efad74a6ea90d58dfe7d68c2767a0e155d0afed3b3d5b8d40206" => :high_sierra
  end

  on_linux do
    depends_on "gawk"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<~EOS
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
