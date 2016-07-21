class Libtbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.5.2.tar.gz"
  sha256 "c470a8a5b8f84d928d83af87c8f69c87ec9ecb6f89017bef93dc0d188e91a8c6"
  head "https://github.com/waruqi/tbox.git"

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--smallest=y", "--demo=n", "--xml=y", "--asio=y", "--thread=y", "--network=y", "--charset=y"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltbox", "-I#{include}", "-o", "test"
    system "./test"
  end
end
