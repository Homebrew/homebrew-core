class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.2.6/libpaper-2.2.6.tar.gz"
  sha256 "500d39dc58768ee09688738c8b5bfe07640ba2fd6c25a6dc78810eb69c719e93"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "8653cd90f7f4e22c810baafa5d035f78fe8b5adc353d8644ab9ac122cc2ac075"
    sha256 arm64_sequoia: "9a86b63104ebab4bdac595a130a961b183f31f1f69aa9b159dfd8166ee673059"
    sha256 arm64_sonoma:  "9bbd54f9c2b9c5f17f14a2cf0fd528283947c63f8a8f372000c65fc94184303d"
    sha256 arm64_ventura: "24bdbc1cd381cd73cc6626d7d07fa57e85008a8394b3b9118b903558fd581b17"
    sha256 sonoma:        "52569069e169b133ce021d5c93d9e84df75b4fbb419e7dc25fa735dd99cf2551"
    sha256 ventura:       "1312df7e0dde77300bb752fd56522edd6ee9d187660fe84cc6f52a6940764dfe"
    sha256 arm64_linux:   "f8c1c59cb54eb45323aa63b5c85d35972b9f093c3548c5928ea57736cfea5660"
    sha256 x86_64_linux:  "d5ac97feb19ebda571a7392c96a099e919d70b9dea6439153e9444dfe79fe252"
  end

  depends_on "help2man" => :build

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    assert_match "A4: 210x297 mm", shell_output("#{bin}/paper --all")
    assert_match "paper #{version}", shell_output("#{bin}/paper --version")

    (testpath/"test.c").write <<~C
      #include <paper.h>
      int main()
      {
        enum paper_unit unit;
        int ret = paperinit();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaper", "-o", "test"
    system "./test"
  end
end
